import 'package:admin_web/Pages/Login_page.dart';
import 'package:admin_web/Pages/RequestPage.dart';
import 'package:admin_web/Pages/myUserTable.dart';
import 'package:admin_web/Pages/signOut_Page.dart';
import 'package:admin_web/Widgets/IconButton.dart';
import 'package:admin_web/Widgets/ManagerData.dart';
import 'package:admin_web/Widgets/PriceDisplay.dart';
import 'package:admin_web/Widgets/appBars.dart';
import 'package:admin_web/Widgets/dailyQuotaDisplay.dart';
import 'package:admin_web/clases/authClass.dart';
import 'package:admin_web/clases/fetchingUserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class home_wid extends StatefulWidget {
  const home_wid({super.key});

  @override
  State<home_wid> createState() => _home_widState();
}

class _home_widState extends State<home_wid> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();
  int _userCount = 0;
  String price = "";
  final _textController = TextEditingController();
  final PriceRegex = RegExp(
    r'^[0-9]+$',
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserCount();
  }

  Future<void> _getUserCount() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('User').get();
      setState(() {
        _userCount = querySnapshot.size;
      });
    } catch (error) {
      print("Error fetching user count: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            appBars(appBarTitle: "Dashboard"),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ManagerData(),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  //
                  width: 20,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: const Color.fromARGB(255, 208, 245, 166),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        DisplayDailyQuota(),
                        SizedBox(height: 30),
                        Text(
                          "Number of users : ${_userCount}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(height: 30),
                        PriceDisplay(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                //
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: const Color.fromARGB(255, 208, 245, 166),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Change Price",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 280,
                            child: TextFormField(
                              controller: _textController,
                              decoration: InputDecoration(
                                labelText: "Enter Price",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Value";
                                }
                                if (!PriceRegex.hasMatch(value)) {
                                  return "Please Enter a Valid Number";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                price = newValue!;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate() == false) {
                                return;
                              }
                              formKey.currentState!.save();

                              try {
                                Map<String, dynamic> liter = {
                                  "Price": price,
                                };
                                await _firestore
                                    .collection('Price')
                                    .doc('5XsRB3BroaZrKDJBNB4a')
                                    .update(liter);
                                Fluttertoast.showToast(
                                  msg: "The Price was Successfully Updated!",
                                  toastLength: Toast
                                      .LENGTH_SHORT, // Duration of the toast
                                );
                              } on FirebaseException catch (e) {
                                print(e.toString());
                              }
                            },
                            child: Text(
                              "Update Price",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _textController.clear();
                            },
                            child: Text(
                              "Clear",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.lightBlueAccent),
                child: MyDataTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
