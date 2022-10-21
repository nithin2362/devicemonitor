import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class WaitScreen extends StatelessWidget {
  const WaitScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF163057),
    ),
    backgroundColor: Color(0xFF002647),
    body: Center(
      child: SpinKitCubeGrid(
            color: Colors.white,
            size: 70.0,
      ),
    ));
  }
}
