import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String title;
  final Icon prefixIcon;
  final bool obscureText;
  final Widget suffixIcon;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final TextInputType keyboardType;
  final String initialValue = "hello";
  final int maxLength;
  final bool readOnly;

  const TextInput({
    Key key,
    this.title,
    this.prefixIcon,
    this.obscureText,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLength,
    this.readOnly
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      readOnly: readOnly??false,
      decoration: InputDecoration(
        isDense: true,
        labelText: title,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        prefixIcon: prefixIcon,
        suffix: suffixIcon,
      ),
      obscureText: obscureText ?? false,
      focusNode: FocusScopeNode(
        canRequestFocus: false,
      ),
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
    );
  }
}
