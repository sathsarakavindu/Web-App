import 'dart:convert';
import 'dart:js_interop';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:admin_web/Widgets/ApproveButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

final firestore = FirebaseFirestore.instance;

class MyDataTable extends StatefulWidget {
  @override
  _MyDataTableState createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  Stream<QuerySnapshot> usersStream = firestore.collection('User').snapshots();
  final TextEditingController _filterController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _filterController.addListener(() {
      setState(() {
        _filter = _filterController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "User Table",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 350,
            height: 40,
            child: TextFormField(
              controller: _filterController,
              decoration: InputDecoration(
                labelText: 'Search by User ID, User name, or NIC',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
              stream: usersStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final usersData = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {'id': doc.id, ...data};
                }).where((userData) {
                  final userId =
                      (userData['User_id'] as String? ?? '').toLowerCase();
                  final userName =
                      (userData['User name'] as String? ?? '').toLowerCase();
                  final nic = (userData['NIC'] as String? ?? '').toLowerCase();
                  return userId.contains(_filter) ||
                      userName.contains(_filter) ||
                      nic.contains(_filter);
                }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'User_ID',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'User Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Mobile',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Address',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'NIC',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Approve',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                    rows: usersData
                        .map((userData) => createDataRow(userData))
                        .toList(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  DataRow createDataRow(Map<String, dynamic> userData) {
    final userId = userData['User_id'] as String? ?? 'Unknown';
    final userName = userData['User name'] as String? ?? '';
    final email = userData['Email'] as String? ?? '';
    final mobile = userData['Mobile'] as String? ?? '';
    final address = userData['Address'] as String? ?? '';
    final nic = userData['NIC'] as String? ?? '';
    var approved = userData['Approve'] as bool? ?? false;
    final docId = userData['id'];

    return DataRow(
      cells: [
        DataCell(Text(userId)),
        DataCell(Text(userName)),
        DataCell(Text(email)),
        DataCell(Text(mobile)),
        DataCell(Text(address)),
        DataCell(Text(nic)),
        DataCell(
          ElevatedButton(
            onPressed: () async {
              var newApproved = !approved;

              try {
                if (!approved) {
                  await firestore.collection('User').doc(docId).update({
                    'Approve': newApproved,
                  });
                  await sendEmail(
                    userName: userName,
                    userMail: email,
                    subject: "Account Approved.",
                    message:
                        "Congratulations! Your account has been approved. Enjoy It!",
                  );
                  await Fluttertoast.showToast(
                    msg: "The User Account was Successfully Approved.!",
                    toastLength: Toast.LENGTH_SHORT,
                  );
                } else {
                  await firestore.collection('User').doc(docId).update({
                    'Approve': newApproved,
                  });
                  await sendEmail(
                    userName: userName,
                    userMail: email,
                    subject: "Account Disabled.",
                    message: "Your account has temporarily been disabled!",
                  );
                  await Fluttertoast.showToast(
                    msg: "The User Account was Disabled.!",
                    toastLength: Toast.LENGTH_SHORT,
                  );
                }

                setState(() {
                  approved = newApproved;
                });
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error updating approval: $error'),
                  ),
                );
              }
            },
            child: Text(approved ? 'Approved' : 'Not Approved'),
          ),
        ),
      ],
    );
  }

  Future sendEmail({
    required String userName,
    required String userMail,
    required String subject,
    required String message,
  }) async {
    final serviceId = 'Your_Service_Id';
    final templateId = 'Your_Template_Id';
    final userId = 'User_Id';
    final privateKey = 'Private_Key';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final msg = jsonEncode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'accessToken': privateKey,
      'template_params': {
        'user_name': userName,
        'user_email': userMail,
        'user_subject': subject,
        'user_message': message,
      },
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: msg,
    );

    print("Email sent: " + response.body);
  }
}
