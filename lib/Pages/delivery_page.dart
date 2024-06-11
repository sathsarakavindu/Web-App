import 'package:admin_web/Pages/Deliver_Table.dart';
import 'package:admin_web/Widgets/appBars.dart';
import 'package:flutter/material.dart';

class Deliver_page extends StatefulWidget {
  const Deliver_page({super.key});

  @override
  State<Deliver_page> createState() => _Deliver_pageState();
}

class _Deliver_pageState extends State<Deliver_page> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: appBars(appBarTitle: "Delivery Page"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.only(left: 100),
                child: Container(
                  width: screenWidth * 0.6,
                  height: 550,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 133, 204, 251),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: DeliverTable(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
