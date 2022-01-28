import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:algorithm_send_location/navigation/my_navigator.dart';
import 'package:flutter/services.dart';

class WarningScreen extends StatefulWidget {
  @override
  _WarningScreen createState() => new _WarningScreen();
}

class _WarningScreen extends State<WarningScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showDialogue(context));
    return Scaffold(
        appBar: AppBar(
          title: Text("Location Sender"),
        ),
        body: Column(
          children: <Widget>[],
        ));
  }
}

showDialogue(BuildContext context) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Warning"),
          content: new Text("Check your network or location setting"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Center(
                    child: new Text(
                      "OK",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                    // Close the dialog
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      });
}
