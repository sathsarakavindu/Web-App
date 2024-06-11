import 'package:admin_web/Pages/ReqTable.dart';
import 'package:admin_web/Widgets/appBars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBars(appBarTitle: "Request Page"),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 100),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Flexible(
                    child: Container(
                      width: 1270,
                      height: 550,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 143, 251, 181),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ReqTable(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
