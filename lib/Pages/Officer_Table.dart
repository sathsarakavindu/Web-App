import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestoreOfficer = FirebaseFirestore.instance;

class Officer_Table extends StatefulWidget {
  const Officer_Table({super.key});

  @override
  State<Officer_Table> createState() => _Officer_TableState();
}

class _Officer_TableState extends State<Officer_Table> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _streamOfficers =
      _firestoreOfficer.collection('Officer').snapshots();

  TextEditingController _filterController = TextEditingController();
  List<Map<String, dynamic>> _officerData = [];
  String _filter = '';

  //01/06/2024
  List<Map<String, dynamic>> _filterData(String filter) {
    filter = filter.trim().toLowerCase();
    if (filter.isEmpty) {
      return _officerData;
    } else {
      return _officerData.where((data) {
        final officerId = data['Officer_id'] as String? ?? '';
        final officerName = data['Officer_name'] as String? ?? '';
        final nic = data['NIC'] as String? ?? '';
        return officerId.toLowerCase().contains(filter) ||
            officerName.toLowerCase().contains(filter) ||
            nic.toLowerCase().contains(filter);
      }).toList();
    }
  }
  //end

  //05/06/2024
  @override
  void initState() {
    // TODO: implement initState
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
  //end

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "Officer Table",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
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
            child: Center(
              child: TextFormField(
                controller: _filterController,
                decoration: InputDecoration(
                  labelText: 'Filter by Officer ID, Name, or NIC',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
              stream: _streamOfficers,
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
                      (userData['Officer_id'] as String? ?? '').toLowerCase();
                  final userName =
                      (userData['Officer_name'] as String? ?? '').toLowerCase();
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
                          'Officer ID',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Officer Name',
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
                          'EPF',
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
                          "Approved",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: usersData
                        .map((userData) => createDataRowOfficer(userData))
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

  DataRow createDataRowOfficer(Map<String, dynamic> userData) {
    final officerId = userData['Officer_id'] as String? ?? 'Unknown';
    final officerName = userData['Officer_name'] as String? ?? '';
    final email = userData['Email'] as String? ?? '';
    final mobile = userData['Mobile'] as String? ?? '';
    final address = userData['Address'] as String? ?? '';
    final epf = userData['EPF'] as String? ?? '';
    final nic = userData['NIC'] as String? ?? '';
    var approve = userData['Approve'] as bool? ?? false;
    final docOfficerId = userData['id'];

    return DataRow(
      cells: [
        DataCell(
          Text(officerId),
        ),
        DataCell(
          Text(officerName),
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
              final newApproved = !approve;

              try {
                if (approve == false) {
                  await _firestore
                      .collection('Officer')
                      .doc(docOfficerId)
                      .update({
                    'Approve': newApproved,
                  });
                  await sendEmail(
                      userName: officerName,
                      userMail: email,
                      subject: "Account Approved.",
                      message:
                          "Congratulations! Your Officer account has been approved. Enjoy It!");

                  setState(() {
                    approve = true;
                  });
                  return; //01/06/2024 return was added.
                } else if (approve == true) {
                  await _firestore
                      .collection('Officer')
                      .doc(docOfficerId)
                      .update({
                    'Approve': newApproved,
                  });
                  await sendEmail(
                      userName: officerName,
                      userMail: email,
                      subject: "Account suspended.",
                      message: "Your account has been temporarily suspended.");
                  setState(() {
                    approve = false;
                  });
                }
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error updating approval: $error'),
                  ),
                );
                setState(() {
                  approve = !newApproved;
                });

                print("The eroor is : $error");
              }
            },
            child: Text(approve ? 'Approved' : 'Not Approved'),
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

    print("Your problem is " + response.body);
  }
}
