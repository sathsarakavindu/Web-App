import 'package:admin_web/Pages/Dashboard.dart';
import 'package:admin_web/Pages/Login_page.dart';
import 'package:admin_web/Pages/home_dashboard.dart';
import 'package:admin_web/clases/authClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignOutPage extends StatefulWidget {
  const SignOutPage({super.key});

  @override
  State<SignOutPage> createState() => _SignOutPageState();
}

class _SignOutPageState extends State<SignOutPage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Sign Out!"),
      content: Text("Are you sure want to sign out?"),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              await FirebaseAuthManagers().signOut();

              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            } on FirebaseException catch (e) {
              print(e.toString());
            }
          },
          child: Text("OK"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard_page(),
              ),
            );
          },
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
