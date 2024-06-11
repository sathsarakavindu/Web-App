import 'package:admin_web/Widgets/Navigation_drawer_widget.dart';
import 'package:flutter/material.dart';

class newDash1 extends StatefulWidget {
  const newDash1({super.key});

  @override
  State<newDash1> createState() => _newDash1State();
}

class _newDash1State extends State<newDash1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      child: Navigation_Drawer_wid(),
    );
  }
}
