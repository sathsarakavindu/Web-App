import 'package:admin_web/Pages/editProfile.dart';
import 'package:flutter/material.dart';

class Navigation_Drawer_wid extends StatefulWidget {
  const Navigation_Drawer_wid({super.key});

  @override
  State<Navigation_Drawer_wid> createState() => _Navigation_Drawer_widState();
}

class _Navigation_Drawer_widState extends State<Navigation_Drawer_wid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationDrawer(
        backgroundColor: const Color.fromARGB(255, 182, 255, 64),
        children: [
          SizedBox(height: 220),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              print("Home");
            },
          ),
          SizedBox(height: 30),
          ListTile(
            leading: Icon(Icons.person_2_outlined),
            title: Text("Edit Profile"),
            onTap: () {
              print("Edit profile");
            },
          ),
          SizedBox(height: 30),
          ListTile(
            leading: Icon(Icons.water_drop_outlined),
            title: Text("Change the daily quota"),
            onTap: () {
              print("Daily quota");
            },
          ),
          SizedBox(height: 30),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text("Log out"),
            onTap: () {
              print("Sign out");
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
