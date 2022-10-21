import 'package:flutter/material.dart';
import 'package:trial123/device.dart';
import 'package:trial123/main.dart';
import 'wait.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
IconData iconData = Icons.abc_outlined;
String deviceName = "";
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
  var dropval;
  void dropDown(Object? icondata)
  {
    if(icondata is IconData)
    {
      setState(() {
        iconData = icondata;  
      });
      
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Add a device",style: TextStyle(color: Colors.white,fontSize: 30))),
        backgroundColor: Color(0xFF163057),
      ),
      backgroundColor:Color.fromARGB(255, 14, 39, 62),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Device Name: ",style: TextStyle(color: Colors.white,fontSize: 20)),
            TextFormField(
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
          ),
          DropdownButton(
          items: [
            DropdownMenuItem<IconData>(child: Text("Light",style: TextStyle(fontSize: 15)),value: Icons.lightbulb),
            DropdownMenuItem<IconData>(child: Text("Fan",style: TextStyle(fontSize: 15)),value: FontAwesomeIcons.fan),
          ],
          value: dropval,
           onChanged: dropDown,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Device added !')));
                    iconData = dropval;
                    var d2 = DateTime.parse(DateTime.now().toString());
                    var isBulb = iconData == Icons.lightbulb ? true:false;
                    dBr.child("${deviceName}").set({"Switch":false,"Last Toggled":d2.toString(),"Bulb":isBulb});
                    setState(() => getDevices(dBr));
                  }
                },
                child: Text("Submit ",style: TextStyle(fontSize: 20)),
                ),
              TextButton(onPressed: () =>Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen())),
                       child: Text("Cancel",style: TextStyle(fontSize: 20,color: Colors.blue))),
              ],
            ),
            
            
          ]),
      ),
    );
  }
}
