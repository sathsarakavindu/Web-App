import 'package:admin_web/Pages/Order_Table.dart';
import 'package:admin_web/Widgets/appBars.dart';
import 'package:flutter/material.dart';

class Order_page extends StatefulWidget {
  const Order_page({super.key});

  @override
  State<Order_page> createState() => _Order_pageState();
}

class _Order_pageState extends State<Order_page> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: appBars(appBarTitle: "Order Page"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.only(left: 190),
                child: Container(
                  width:
                      screenWidth * 0.6, // Use a percentage of the screen width
                  height: 500,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 133, 204, 251),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Order_Table(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
