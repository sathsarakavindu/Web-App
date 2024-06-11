import 'package:admin_web/Pages/DriverTable.dart';
import 'package:admin_web/Widgets/appBars.dart';
import 'package:flutter/material.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBars(appBarTitle: "Driver Page"),
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: screenWidth *
                        0.9, // Use a percentage of the screen width
                    height: 600,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Color.fromARGB(255, 136, 231, 217),
                    ),
                    child: DriverTable(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
