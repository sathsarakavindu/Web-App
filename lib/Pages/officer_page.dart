import 'package:admin_web/Pages/Officer_Table.dart';
import 'package:admin_web/Widgets/appBars.dart';
import 'package:flutter/material.dart';

class Officer_page extends StatefulWidget {
  const Officer_page({super.key});

  @override
  State<Officer_page> createState() => _Officer_pageState();
}

class _Officer_pageState extends State<Officer_page> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: appBars(appBarTitle: "Officer Page"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Container(
                width:
                    screenWidth * 0.9, // Use a percentage of the screen width
                height: 600,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Color.fromARGB(255, 136, 231, 217),
                ),
                child: Officer_Table(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
