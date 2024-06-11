import 'package:admin_web/Pages/DriverPage.dart';
import 'package:admin_web/Pages/RequestPage.dart';
import 'package:admin_web/Pages/changeQuota.dart';
import 'package:admin_web/Pages/delivery_page.dart';
import 'package:admin_web/Pages/editProfile.dart';
import 'package:admin_web/Pages/home_dashboard.dart';
import 'package:admin_web/Pages/officer_page.dart';
import 'package:admin_web/Pages/orders_page.dart';
import 'package:admin_web/Pages/signOut_Page.dart';
import 'package:admin_web/Widgets/IconButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard_page extends StatefulWidget {
  const Dashboard_page({Key? key}) : super(key: key);

  @override
  State<Dashboard_page> createState() => _Dashboard_pageState();
}

class _Dashboard_pageState extends State<Dashboard_page> {
  final List<Widget> _screens = [
    home_wid(),
    Edit_Profile(),
    Container(
      child: ChangeQuota(),
    ),
    RequestPage(),
    Deliver_page(),
    Officer_page(),
    DriverPage(),
    Order_page(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              unselectedItemColor: Colors.grey,
              selectedItemColor: Colors.indigoAccent,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.feed), label: 'Edit Profile'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.water_drop), label: 'Change Daily Quota'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.request_page), label: 'Request'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.delivery_dining), label: 'Deliver'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_sharp), label: 'Officers'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.drive_eta_rounded), label: 'Drivers'),
                BottomNavigationBarItem(icon: Icon(Icons.gif), label: 'Order'),
              ],
            )
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 640)
            Flexible(
              flex: 1,
              child: NavigationRail(
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                backgroundColor: Color.fromARGB(255, 134, 209, 244),
                minWidth: 300,
                selectedIndex: _selectedIndex,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_2_outlined),
                    label: Text('Edit Profile'),
                    padding: EdgeInsets.only(top: 15),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.water_drop),
                    label: Text("Change Daily Quota"),
                    padding: EdgeInsets.only(top: 15),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.request_page_sharp),
                    label: Text("Request"),
                    padding: EdgeInsets.only(top: 15),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.delivery_dining_sharp),
                    label: Text("Delivered"),
                    padding: EdgeInsets.only(top: 15),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_outlined),
                    label: Text("Officers"),
                    padding: EdgeInsets.only(top: 15),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.drive_eta_rounded),
                    label: Text("Drivers"),
                    padding: EdgeInsets.only(top: 15),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.gif_box_outlined),
                    label: Text("Order"),
                    padding: EdgeInsets.only(top: 15),
                  ),
                ],
              ),
            ),
          Expanded(
            flex: 4,
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
