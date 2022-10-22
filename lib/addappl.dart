import 'package:flutter/material.dart';
import 'package:trial123/device.dart';
import 'package:trial123/main.dart';
import 'wait.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
//IconData iconData = Icons.abc_outlined;

class DeviceAdd extends StatefulWidget {
  // String deviceName;
  // IconData iconData;
  // DeviceAdd(this.deviceName,this.iconData);
  const DeviceAdd({ Key? key }) : super(key: key);
  @override
  State<DeviceAdd> createState() => _DeviceAddState();
}

class _DeviceAddState extends State<DeviceAdd> {
  @override
  final _formKey = GlobalKey<FormState>();
  final dBr = FirebaseDatabase.instance.ref();
  String? value;
  String? dropval,ic;
  String deviceName = "",icon = "";
  // void dropDown(Object? icondata)
  // {
  //   if(icondata is IconData)
  //   {
  //     setState(() {
  //       iconData = icondata;  
  //     });
      
  //   }
  // }
  final _controller = TextEditingController();
  final items = ["Light","Fan"];
    DropdownMenuItem<String> buildItem(String data)
  {
    return DropdownMenuItem(
      value: data,
      child: Text(
        data,
        style: TextStyle(fontSize: 15, color: Colors.white,fontWeight: FontWeight.bold),),
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Add a device",style: TextStyle(color: Colors.white,fontSize: 20))),
        backgroundColor: Color(0xFF163057),
      ),
      backgroundColor:Color.fromARGB(255, 14, 39, 62),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Device Name",style: TextStyle(color: Colors.white,fontSize: 20)),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                ),
          
                child: TextFormField(
                controller: _controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some valid Device name !';
                  }
                  else
                  {
                    deviceName = value;
                  }
                  return null;
                },
               )),
        ),
            SizedBox(
              height: 30,
            ),
          Text("Device Icon",style: TextStyle(color: Colors.white,fontSize: 20)),
          DropdownButton<String>(
          items: items.map(buildItem).toList(),
          dropdownColor: Color.fromARGB(255, 81, 113, 161),
          value: value,
           onChanged: (value) => setState(() => this.value = value),
            ),
            SizedBox(height: 30,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 50,right: 50,top:20,bottom: 20),
                  child: ElevatedButton(
                  
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Device added !')));
                      //iconData = dropval;
                      var d2 = DateTime.parse(DateTime.now().toString());
                      var isBulb = this.value == "Light";
                      dBr.child("${deviceName}").set({"Switch":false,"Last Toggled":d2.toString(),"Bulb":isBulb});
                      setState((){});
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                    }
                  },
                  child: Text("Add ",style: TextStyle(fontSize: 20)),
                  ),
                ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: TextButton(onPressed: () =>Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen())),
                         child: Text("Cancel",style: TextStyle(fontSize: 20,color: Colors.blue))),
              ),
              ],
            ),
            
            
          ]),
      ),
    );

  
  
  }
}
