import 'package:admin_web/Pages/DailyQuotaTable.dart';
import 'package:admin_web/Widgets/Elevated_buttons.dart';
import 'package:admin_web/Widgets/TextWidgets.dart';
import 'package:admin_web/Widgets/appBars.dart';
import 'package:admin_web/Widgets/dailyQuotaDisplay.dart';

import 'package:admin_web/clases/Manager.dart';
import 'package:admin_web/clases/ManagerService.dart';
import 'package:admin_web/clases/fetchingUserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeQuota extends StatefulWidget {
  const ChangeQuota({super.key});

  @override
  State<ChangeQuota> createState() => _ChangeQuotaState();
}

class _ChangeQuotaState extends State<ChangeQuota> {
  final FirebaseFirestore _firestoreQuota = FirebaseFirestore.instance;
  double newQuota = 0;
  double newAval = 0;
  double difference = 0;
  String Q_value = "";
  String different_String = "";
  double newAvalilableWithTotal_ = 0;
  DateTime nowTime = DateTime.now();
  final QuotaRegex = RegExp(
    r'^[0-9]+$',
  );
  final _formKey_Q = GlobalKey<FormState>();

  String manager_ID = "";
  final _quotaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: appBars(appBarTitle: "Change Daily Quota"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 251, 182, 254),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: DailyQuotaTable(),
                  ),
                ),
                SizedBox(
                  width: 180,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Color.fromARGB(255, 200, 240, 154),
                    ),
                    child: Form(
                      key: _formKey_Q,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 70),
                          DisplayDailyQuota(),
                          SizedBox(height: 30),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.water_drop_outlined),
                                labelText: "Enter Updated Value",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Value";
                                }
                                if (!QuotaRegex.hasMatch(value)) {
                                  return "Please enter a valid number";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                Q_value = newValue!;
                              },
                            ),
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            height: 50,
                            child: Elebutton(
                                btnTxt: "Update",
                                onPressed: () async {
                                  if (_formKey_Q.currentState!.validate() ==
                                      false) {
                                    return;
                                  }
                                  _formKey_Q.currentState!.save();

                                  String formattedTime =
                                      nowTime.toString().substring(11, 16);
                                  DateTime now = DateTime.now();
                                  String formattedDate =
                                      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

                                  try {
                                    Map<String, dynamic> Quota = {
                                      "Daily Quota": Q_value,
                                      "Date": formattedDate,
                                      "Time": formattedTime,
                                    };
                                    await _firestoreQuota
                                        .collection('Daily_Quota')
                                        .doc('5orn8RD56WOMqXAaU3ly')
                                        .update(Quota);

                                    await updateAllDailyQuota(Q_value);

                                    await _printAllAvailableValues();

                                    await Fluttertoast.showToast(
                                      msg:
                                          "The Daily Quota was Successfully Updated!",
                                      toastLength: Toast
                                          .LENGTH_SHORT, // Duration of the toast
                                    );
                                  } on FirebaseException catch (e) {
                                    print("Your fault is : ${e.toString()}");
                                  }
                                },
                                btnColor: Color.fromARGB(255, 122, 182, 246)),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            child: Elebutton(
                                btnTxt: "Cancel",
                                onPressed: () {},
                                btnColor: Color.fromARGB(255, 240, 124, 217)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateAllDailyQuota(String newQuota) async {
    // Create a query to get all users
    final users = await _firestoreQuota.collection('User').get();

    // Batch write to update documents efficiently
    final batch = _firestoreQuota.batch();

    users.docs.forEach((doc) {
      // Update the "Daily Quota" field for each user
      batch.update(doc.reference, {'Daily Quota': newQuota});
    });

    // Commit the batch write
    await batch.commit();

    print('Daily Quota successfully updated for all users!');
  }

  Future<void> _printAllAvailableValues() async {
    var users = await _firestoreQuota.collection('User').get();

    for (var userDoc in users.docs) {
      var userData = userDoc.data();
      newQuota = double.parse(userData['Daily Quota']);
      newAval = double.parse(userData['Available']);
      if (newAval <= newQuota) {
        difference = newQuota - newAval;

        newAvalilableWithTotal_ = newAval + difference;

        different_String = newAvalilableWithTotal_.toString();

        await userDoc.reference.update({
          'Available': different_String,
        });

        print("Difference : ${difference.toString()}");
      } else {
        await userDoc.reference.update({
          'Available': Q_value,
        });
      }
    }
  }
}
