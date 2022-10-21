import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
String str1 = "";
var dBr;

class Loader extends StatefulWidget {
  //const Loader({ Key? key }) : super(key: key);
  Loader(final dBr1){
    dBr = dBr1;
  }
  @override
  State<Loader> createState() => _LoaderState();
}
Future<void> getData() async
{
  str1 = dBr.child("Light").child("Switch");
}
class _LoaderState extends State<Loader> {
  @override
  Map m1 = {1:"ON",0:"OFF"};
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: getData(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            child: Text(
              "Found some error"
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Container();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
  }
}