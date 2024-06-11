import 'package:flutter/material.dart';

class Elebutton extends StatefulWidget {
  String btnTxt = "";
  Color? btnColor;
  void Function()? onPressed;

  Elebutton(
      {super.key,
      required this.btnTxt,
      required this.onPressed,
      required this.btnColor});

  @override
  State<Elebutton> createState() => _ElebuttonState();
}

class _ElebuttonState extends State<Elebutton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(widget.btnColor),
      ),
      onPressed: widget.onPressed,
      child: Text(
        widget.btnTxt,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
