import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final _firestoreDriver = FirebaseFirestore.instance;

class DriverTable extends StatefulWidget {
  const DriverTable({super.key});

  @override
  State<DriverTable> createState() => _DriverTableState();
}

class _DriverTableState extends State<DriverTable> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _streamDrivers =
      _firestoreDriver.collection('Driver').snapshots();
  TextEditingController _filterController = TextEditingController();
  String _filter = "";

  @override
  void initState() {
    super.initState();
    _filterController.addListener(() {
      setState(() {
        _filter = _filterController.text;
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
            "Driver Table",
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
            height: 40,
            width: 350,
            child: TextFormField(
              controller: _filterController,
              decoration: InputDecoration(
                labelText: 'Filter by Driver Id, Driver Name, or NIC',
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
              stream: _streamDrivers,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error : ${snapshot.error}");
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final _DriverData = snapshot.data!.docs.map((doc) {
                  final data =
                      doc.data() as Map<String, dynamic>; // Cast data to Map
                  return {'id': doc.id, ...data};
                }).toList();

                final filteredData = _DriverData.where((element) {
                  final driverId = element['Driver_id'] as String? ?? '';
                  final driverName = element['Driver_name'] as String? ?? '';
                  final nic = element['NIC'] as String? ?? '';
                  final filter = _filter.toLowerCase();

                  return driverId.toLowerCase().contains(filter) ||
                      driverName.toLowerCase().contains(filter) ||
                      nic.toLowerCase().contains(filter);
                }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          "Driver Id",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Driver Name",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Mobile",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Address",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "EPF",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "NIC",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Approved",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: filteredData
                        .map((userData) => createDataRowDriver(userData))
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

  DataRow createDataRowDriver(Map<String, dynamic> userData) {
    final DriverId = userData['Driver_id'] as String? ?? 'Unknown';
    final DriverName = userData['Driver_name'] as String? ?? '';
    final email = userData['Email'] as String? ?? '';
    final mobile = userData['Mobile'] as String? ?? '';
    final address = userData['Address'] as String? ?? '';
    final epf = userData['EPF'] as String? ?? '';
    final nic = userData['NIC'] as String? ?? '';
    var approved = userData['Approve'] as bool? ?? false;
    final docDriverId = userData['id'];

    return DataRow(
      cells: [
        DataCell(
          Text(DriverId),
        ),
        DataCell(
          Text(DriverName),
        ),
        DataCell(
          Text(email),
        ),
        DataCell(
          Text(mobile),
        ),
        DataCell(
          Text(address),
        ),
        DataCell(
          Text(epf),
        ),
        DataCell(
          Text(nic),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () async {
              print(approved); //true
              var newApproved = !approved; //false

              try {
                if (approved == false) {
                  await _firestore
                      .collection('Driver')
                      .doc(docDriverId)
                      .update({
                    'Approve': newApproved,
                  });
                  //call email notification method
                  await sendEmail(
                      userName: DriverName,
                      userMail: email,
                      subject: "Driver Account Approved.",
                      message:
                          "Congratulations! Your Driver account has been approved. Enjoy It!");
                  setState(() {
                    approved = true;
                  });
                } else if (approved == true) {
                  await _firestore
                      .collection('Driver')
                      .doc(docDriverId)
                      .update({
                    'Approve': newApproved,
                  });
                  await sendEmail(
                      userName: DriverName,
                      userMail: email,
                      subject: "Driver Account Disabled.",
                      message:
                          "Your Driver account has temporarily been disabled.");
                  setState(() {
                    approved = false;
                  });
                }

                print(docDriverId);
              } catch (error) {
                // Handle update error (e.g., show a snackbar)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error updating approval: $error'),
                  ),
                );

                print("The eroor is : $error");
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

    print("Kavindu, Your problem is " + response.body);
  }
}
