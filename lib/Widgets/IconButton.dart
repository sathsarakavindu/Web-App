import 'package:flutter/material.dart';

class IconBtn extends StatefulWidget {
  void Function()? onFunctionPress;
  Widget My_Icons;

  IconBtn({super.key, required this.onFunctionPress, required this.My_Icons});

  @override
  State<IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<IconBtn> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onFunctionPress,
      icon: widget.My_Icons,
    );
  }
}
