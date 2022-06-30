import 'package:flutter/material.dart';
import 'package:user_major/constants.dart';

Widget attendanceButton({required Function function}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: function(),
        color: greenColor,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Contact',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    ),
  );
}
