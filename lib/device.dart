import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:trial123/addappl.dart';
import 'package:trial123/notification.dart';
Color bulbcolor = Colors.white;
bool isOn = false,isBulb = true;
double iconsize = 70;
int cnt = 1,timeDifference = 10;
late final LocalNotificationService service = LocalNotificationService();
String bulbtext = "Off",state = "",dtext = "Unavailable",diff = "";
DateTime d1 = DateTime.now(),d2 = DateTime.now();
int num = 0;

class Device extends StatefulWidget {
  final String path,dname;
  final IconData iconData;
  final bool smart;
  Future<void> notify(var ref,int id1) async
  {
    final snap = await ref.child("personCount").get();
    if(snap.exists)
    {
      cnt = snap.value;
    }
    print("Count: $cnt, Diff: $timeDifference, isOn: $isOn");
    if(cnt < 1 && timeDifference >= 5 && isOn == true)
    {
      // service.initialize();
      await service.showNotification(id: id1, title: "${dname}", body: "You forgot to turn off ${dname} !");
      
    }
  }

  Future<void> getTime(var ref) async
  {

    // final snap = await ref.child("personCount").get();
    final snap1 = await ref.child("${path}/Last Toggled").get();
    if(snap1.exists)
    {
      d1 = DateTime.parse(snap1.value);
      d2 = DateTime.parse(DateTime.now().toString());
      timeDifference = d2.difference(d1).inMinutes;
      diff = timeDifference <= 60 ? d2.difference(d1).inMinutes.toString() + " minute(s) ago" : d2.difference(d1).inHours.toString() + " hour(s) ago";
    }
    else
      {
        dtext = "Unavailable";
        diff = "Last Toggle data unavailable";
      }
    // if(snap.exists)
    // {
    //   cnt = snap.value;
    // }
    // if(cnt < 1 && v1 >= 5 && isOn == true)
    // {
    //   await service.showNotification(id: 0, title: "${widget.dname}", body: "You forgot to turn off ${widget.dname} !");
    //   isnotified = true;
    // }

  }
  Future<void> getVal(var ref) async
  {
    //final snapshot = await ref.child("${widget.path}/Switch").get();
    final snapshot = await ref.child("${path}").get();
    if (snapshot.exists) {
      Map m1 = snapshot.value;
      isOn = m1["Switch"];
      isBulb = m1["Bulb"];
      if(isOn)
      { bulbcolor = isBulb ? Colors.yellow : Colors.blue;}
      else
      { bulbcolor = Colors.white; }
      
      bulbtext = isOn ? "On" : "Off";
      
    }
    else {
        bulbcolor = Colors.white;
        bulbtext = "Unavailable";
    } 
    await getTime(ref);
  }
  
  Device(this.dname,this.path,this.iconData,this.smart);
  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  @override
  // int num = 0;
  // String bulbtext = "Off",state = "",dtext = "Unavailable",diff = "";
  // DateTime d1 = DateTime.now(),d2 = DateTime.now();
  final dBr = FirebaseDatabase.instance.ref();
  bool isViewed = false;
  late final LocalNotificationService service;
  var tim = Timer.periodic(const Duration(seconds:60),(timer) { });
  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    super.initState();
    tim = Timer.periodic(Duration(seconds: 60), (timer) {
     getTime(dBr);
      setState(() {});
      
    });
     if(isViewed)
        tim.cancel();
  }
  @override
  void dispose() {
    isViewed = true;
    tim.cancel();
    super.dispose();
  }
  
  Future<void> notify(var ref,int id) async
  {
    final snap = await ref.child("personCount").get();
    if(snap.exists)
    {
      cnt = snap.value;
    }
    if(cnt < 1 && timeDifference >= 5 && isOn == true)
    {
      await service.showNotification(id: id, title: "${widget.dname}", body: "You forgot to turn off ${widget.dname} !");
      
    }
  }

  Future<void> getTime(var ref) async
  {

    // final snap = await ref.child("personCount").get();
    final snap1 = await ref.child("${widget.path}/Last Toggled").get();
    if(snap1.exists)
    {
      d1 = DateTime.parse(snap1.value);
      d2 = DateTime.parse(DateTime.now().toString());
      timeDifference = d2.difference(d1).inMinutes;
      diff = timeDifference <= 60 ? d2.difference(d1).inMinutes.toString() + " minute(s) ago" : d2.difference(d1).inHours.toString() + " hour(s) ago";
    }
    else
      {
        dtext = "Unavailable";
        diff = "Last Toggle data unavailable";
      }
    // if(snap.exists)
    // {
    //   cnt = snap.value;
    // }
    // if(cnt < 1 && v1 >= 5 && isOn == true)
    // {
    //   await service.showNotification(id: 0, title: "${widget.dname}", body: "You forgot to turn off ${widget.dname} !");
    //   isnotified = true;
    // }

  }
  Future<void> getVal(var ref) async
  {
    //final snapshot = await ref.child("${widget.path}/Switch").get();
    final snapshot = await ref.child("${widget.path}").get();
    if (snapshot.exists) {
      Map m1 = snapshot.value;
      isOn = m1["Switch"];
      isBulb = m1["Bulb"];
      if(isOn)
        bulbcolor = isBulb ? Colors.yellow : Colors.blue;
      else
        bulbcolor = Colors.white;
      bulbtext = isOn ? "On" : "Off";
      
    }
    else {
        bulbcolor = Colors.white;
        bulbtext = "Unavailable";
    } 
    await getTime(dBr);
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back,
        //   color: Colors.white,
        //   size: 20,
        //   ),
        //   onPressed: (){
        //     setState(() {
        //       isViewed = true;
        //   });
        //   Navigator.pop(context);
        //   },
        //   ),
        title: Center(child: Text("${widget.dname}")),
        backgroundColor: Color(0xFF163057),
      ),
      backgroundColor:Color(0xFF002647),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FutureBuilder(
              future: getVal(dBr),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done)
                {
                  return Column(
                    children: [
                  IconButton(icon: Icon(widget.iconData,size: iconsize,),
                  color: bulbcolor,
                  onPressed: (){
                    isOn = !isOn;
                    d2 = DateTime.parse(DateTime.now().toString());
                    isBulb = widget.iconData == Icons.lightbulb;
                    diff = d2.difference(d1).inMinutes.toString();
                    dBr.child("${widget.path}").set({"Switch":isOn,"Last Toggled":d2.toString(),"Bulb":isBulb});
                    Future.delayed(const Duration(milliseconds: 2000), () {
                        setState(() {
                          if(isOn)
                            bulbcolor = isBulb ? Colors.yellow : Colors.blue;
                          else
                            bulbcolor = Colors.white;
                          bulbtext = isOn ? "On" : "Off";
                          });

                        });
                  },
                  iconSize: 70.0,
                  ),
                  Center(
                    child: Text(
                      "$bulbtext",
                      style: TextStyle(color: Colors.white,fontSize: 40.0,fontWeight: FontWeight.bold),

                    ),
                  ),
                  Center(
                    child: Text(
                      "\n$diff",
                      style: TextStyle(color: Colors.white,fontSize: 20.0),

                    ),
                  ),
                  // Center(
                  //   child: ElevatedButton(onPressed: () async
                  //   {
                  //     await service.showNotification(id: 0, title: "Message", body: "This is a notification");
                  //   },
                  //   child: Text("Press me !",style: TextStyle(color: Colors.white,fontSize: 30),)),
                  //   ),
                  ]);
                }
                else
                { num++;
              return Center(
                          child: SpinKitCubeGrid(
                                color: Colors.white,
                                size: 70.0,
                                
                              ),
                  );
                }
              }
            ),
            
            
          ]
        
    ),
      ));
}
}