import 'package:flutter/material.dart';
import 'package:user_major/constants.dart';

Widget buildInfoBoxes({required Icon icon, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 50.0,
      vertical: 4.0,
    ),
    child: Container(
      width: 50.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: greenColor,
        ),
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListTile(
          leading: icon,
          title: Text(
            value,
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    ),
  );
}