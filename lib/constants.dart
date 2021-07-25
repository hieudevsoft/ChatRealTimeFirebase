import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

final kElevatedButtonStyle = ButtonStyle(
    alignment: Alignment.center,
    animationDuration: Duration(milliseconds: 1),
    elevation: MaterialStateProperty.resolveWith<double>(
      (states) {
        if (states.contains(MaterialState.pressed) ||
            states.contains(MaterialState.focused))
          return 20;
        else
          return 0;
      },
    ),
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(MaterialState.pressed) ||
            states.contains(MaterialState.focused))
          return Colors.white;
        else
          return Colors.black;
      },
    ),
    enableFeedback: true,
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(MaterialState.pressed) ||
            states.contains(MaterialState.focused))
          return Colors.black;
        else
          return Colors.blueAccent;
      },
    ),
    minimumSize: MaterialStateProperty.resolveWith<Size>(
      (states) {
        if (states.contains(MaterialState.pressed) ||
            states.contains(MaterialState.focused))
          return Size.fromHeight(48);
        else
          return Size.fromHeight(48);
      },
    ),
    overlayColor: MaterialStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(MaterialState.pressed) ||
            states.contains(MaterialState.focused))
          return Colors.blueGrey;
        else
          return Colors.blueAccent;
      },
    ),
    padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
      (states) {
        if (states.contains(MaterialState.pressed) ||
            states.contains(MaterialState.focused))
          return EdgeInsets.fromLTRB(0, 0, 0, 5);
        else
          return EdgeInsets.all(0);
      },
    ),
    shadowColor: MaterialStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(MaterialState.pressed) ||
            states.contains(MaterialState.focused))
          return Colors.grey;
        else
          return Colors.black;
      },
    ),
    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
      (states) {
        if (states.contains(MaterialState.pressed) ||
            states.contains(MaterialState.focused))
          return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), side: BorderSide.none);
        else
          return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), side: BorderSide.none);
      },
    ));
const kMessageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    hintText: 'Type your message here...',
    border:
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32)),
      borderSide: BorderSide(width: 1, color: Colors.white),
    ));
const kMessageContainerDecoration = BoxDecoration(
  color: Colors.black45,
  border: Border(),
);
const inputDecorationRegister = InputDecoration(
    hintText: 'text',
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    errorStyle:
        TextStyle(color: Colors.red, fontSize: 12, fontFamily: "Avenir"),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ));
