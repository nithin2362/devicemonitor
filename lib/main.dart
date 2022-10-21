import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'wait.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'device.dart';
import 'addappl.dart';

//import 'appliance.dart';
void main() {
  runApp(
  RootRestorationScope(restorationId: "root", child: MaterialApp(
  home: FBLoad(),
    // theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
  )));
    
}
class FBLoad extends StatelessWidget {
  const FBLoad({ Key? key }) : super(key: key);
  
  @override
   Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) 
        {
          return Container(
            child: Text(
              "Found some error"
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return HomeScreen();
          //return Device(mm1);
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return WaitScreen();
      },
    );
  }
}
int id = 0;
Future<void> getDevices(var dBr) async
  {
    final snapshot = await dBr.get();
    if(snapshot.exists)
    {
      Map devs = snapshot.value;
      var k = devs.keys.toList();
      var v = devs.values.toList();
      print(k);
      print(v);
      for(int i = 0;i<k.length;++i)
      {
        if(deviceNames.indexWhere((element) =>element == k[i]) < 0)
        {
          IconData ic = v[i]["Bulb"] == true ? Icons.lightbulb : FontAwesomeIcons.fan;
          devices.add(new Device(k[i],k[i],ic,true));
          deviceNames.add(k[i]);
          await devices[i].getVal(dBr);
          await devices[i].notify(dBr,id);
          ++id;
        }
      }
    }
  else
  {
    print("\nDevices not found !!");
  }
    
  }
class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
@override
List<Device> devices = [];
List<String> deviceNames = [];
class _HomeScreenState extends State<HomeScreen>{
  @override
  void initState()
  {
    super.initState();
    
  }
  @override
  void dispose() {
    super.dispose();
  }
  
  final dBr = FirebaseDatabase.instance.ref();
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDevices(dBr),
      builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.done)
      {
        return Scaffold(
            appBar: AppBar(title: Center(child: Text("Living Room",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)),backgroundColor: Color(0xFF163057),
            actions: [
              IconButton(onPressed: (){
                    
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DeviceAdd()));
                    
                    // setState(() {
                    //   if(deviceNames.length < 3)
                    //     dBr.child("Fan").set({"Bulb":false,"Last Toggled":DateTime.parse(DateTime.now().toString()).toString(),"Switch":false});
                    // });
              
            }, icon: Icon(Icons.add,color: Colors.white,size: 40),),
            ],
            ),
            backgroundColor:Color.fromARGB(255, 14, 39, 62),
            body: ListView.builder(
                // Let the ListView know how many items it needs to build.
                itemCount: devices.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  final item = devices[index];

                  return Container(
                    color: Color.fromARGB(255, 81, 113, 161),
                    height: 60,
                    child: ListTile(
                      title: Padding(padding:EdgeInsets.only(left: 80),child: Text("${item.dname}",style: TextStyle(color: Colors.white,fontSize: 20.0),)),
                      leading: Icon(item.iconData,color: Colors.white,size: 40),
                      iconColor: bulbcolor,
                      trailing: IconButton(icon: Icon(Icons.delete),iconSize: 40,color:Colors.red,onPressed: (){
                        setState(() {
                          dBr.child(item.dname).remove();
                          devices.remove(item);
                          deviceNames.remove(item.dname);
                        });
                      },),
                      onTap: ()
                      {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => item));
                      }
                      
                    ),
                  );
                },
              ),
          );
      }
    else
      return Scaffold(
        backgroundColor:Color(0xFF002647),
        body: Center(
        child: SpinKitCubeGrid(
              color: Colors.white,
              size: 70.0,
              
            ),
        ),
      );
    }
     );
    
    
    
    
    
    
    
  }
}
