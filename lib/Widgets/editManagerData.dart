import 'package:admin_web/clases/Manager.dart';
import 'package:admin_web/clases/ManagerService.dart';
import 'package:flutter/material.dart';

class EditManagerProfile extends StatefulWidget {
  const EditManagerProfile({super.key});

  @override
  State<EditManagerProfile> createState() => _EditManagerProfileState();
}

class _EditManagerProfileState extends State<EditManagerProfile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ManagerEdit?>(
      future: ManagerServiceEdit().getLoggedInManagerEdit(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text("Data are avilable");
        } else {
          return Text("no data");
        }
      },
    );
  }
}
