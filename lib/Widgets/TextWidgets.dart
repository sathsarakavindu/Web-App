import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  String hintText = "";
  bool isPassword = false;
  String textLabel = "";
  String? Function(String?)? validator;
  void Function(String?)? onSave;
  Widget icon;

  TextWidget({
    super.key,
    required this.isPassword,
    required this.validator,
    required this.onSave,
    required this.icon,
    required this.textLabel,
  });

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: widget.textLabel,
          icon: widget.icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          hintText: widget.hintText,
          iconColor: Colors.black),
      obscureText: widget.isPassword,
      validator: widget.validator,
      onSaved: widget.onSave,
    );
  }
}
