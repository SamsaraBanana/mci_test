import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final bool obscureText;
  final GlobalKey formKey;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final InputDecoration decoration;
  final TextInputType keyboardType;

  const LoginTextField(
    {
      super.key,
      required this.obscureText,
      required this.controller,
      required this.formKey,
      required this.validator,
      required this.decoration,
      this.keyboardType = TextInputType.text
    }
  );

  @override
  Widget build(BuildContext context) {

    return Form(
      key: formKey,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: decoration,
        obscureText: obscureText,
      ),
    );
  }
}


///  TextField Decoration
InputDecoration usernameTextFieldDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    errorMaxLines: 2,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    border: const OutlineInputBorder(),
  );
}

InputDecoration passwordTextFieldDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    errorMaxLines: 2,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    border: const OutlineInputBorder(),
  );
}