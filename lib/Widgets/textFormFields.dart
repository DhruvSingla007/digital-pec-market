import 'package:flutter/material.dart';

Widget formFields({
  required String errorMessage,
  required String hintText,
  required Icon preIcon,
  required TextEditingController editingController,
  IconButton? suffixIconButton,
  required bool isObscure,
}) {

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
    child: TextFormField(
      validator: (value) {
        if (value == null || value == "") {
          return errorMessage;
        }
        return null;
      },
      obscureText: isObscure,
      controller: editingController,
      decoration: InputDecoration(
        suffixIcon: suffixIconButton,
        suffixIconColor: Colors.black,
        prefixIcon: preIcon,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    ),
  );
}
