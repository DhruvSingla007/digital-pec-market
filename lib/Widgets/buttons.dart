import 'package:flutter/material.dart';
import 'package:user_major/constants.dart';

Widget buttons({required Function function, required Widget widget}) {
  return RaisedButton(
    onPressed: () {
      function();
    },
    color: Colors.blueGrey,
    child: widget,
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(10.0),
    ),
    elevation: 6.0,
  );
}
