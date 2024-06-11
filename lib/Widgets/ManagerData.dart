import 'package:admin_web/clases/Manager.dart';
import 'package:admin_web/clases/ManagerService.dart';
import 'package:flutter/material.dart';

class ManagerData extends StatefulWidget {
  const ManagerData({super.key});

  @override
  State<ManagerData> createState() => _ManagerDataState();
}

class _ManagerDataState extends State<ManagerData> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Manager?>(
      future: ManagerService().getLoggedInManager(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final manager = snapshot.data!;
          return Text(
            "Hi ${manager.managerName}",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          );
        } else if (snapshot.hasError) {
          return Text("Error : ${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }
}
