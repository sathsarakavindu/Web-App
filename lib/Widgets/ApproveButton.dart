import 'package:flutter/material.dart';

class ApproveButton extends StatefulWidget {
  String btnTxt = "Not Approved";

  ApproveButton({super.key, required this.btnTxt});

  @override
  State<ApproveButton> createState() => _ApproveButtonState();
}

class _ApproveButtonState extends State<ApproveButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (widget.btnTxt == "Not Approved") {
            widget.btnTxt = "Approved";
          } else {
            widget.btnTxt = "Not Approved";
          }
        });
      },
      child: Text(widget.btnTxt),
    );
  }
}
