import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:admin_web/Widgets/Elevated_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firebaseReq = FirebaseFirestore.instance;

class ReqTable extends StatefulWidget {
  const ReqTable({super.key});

  @override
  State<ReqTable> createState() => _ReqTableState();
}

class _ReqTableState extends State<ReqTable> {
  double newAval = 0;
  String newAval_D = "";
  double aval = 0;
  String userAval = "";
  String userEmail = "";
  String userName = "";
  Stream<QuerySnapshot> _streamReq =
      _firebaseReq.collection('Request').snapshots();

  String documentID = "";
  String userID_ = "";

  TextEditingController _filterController = TextEditingController();
  String _filter = "";

  Future<void> getData() async {
    try {
      // Replace 'Request' with your actual collection name
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Request').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Access the document ID using doc.id
        setState(() {
          documentID = doc.id;
        });

        print('Document ID: ${documentID}');
      }
    } catch (e) {
      print('Error getting documents: $e');
    }
  }

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
            "Request Table",
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
            height: 40,
            width: 300,
            child: TextFormField(
              controller: _filterController,
              decoration: InputDecoration(
                labelText: 'Filter by Request ID, User ID, or User Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
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
              stream: _streamReq,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final _ReqData = snapshot.data!.docs.map((doc) {
                  final data =
                      doc.data() as Map<String, dynamic>; // Cast data to Map

                  return {'id': doc.id, ...data};
                }).toList();

                final filteredData = _ReqData.where((element) {
                  final requestId = element['Request_id'] as String? ?? '';
                  final userId = element['User_id'] as String? ?? '';
                  final userName = element['User_name'] as String? ?? '';
                  final filter = _filter.toLowerCase();

                  return requestId.toLowerCase().contains(filter) ||
                      userId.toLowerCase().contains(filter) ||
                      userName.toLowerCase().contains(filter);
                }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          "Request Id",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "User Id",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "User Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Address",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text(
                            "Statement",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Time",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Approved",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ],
                    rows: filteredData
                        .map((userData) => createDataRowRequest(userData))
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

  DataRow createDataRowRequest(Map<String, dynamic> userData) {
    final requestId = userData['Request_id'] as String? ?? 'Unknown';
    final userID = userData['User_id'] as String? ?? 'Unknown';
    final user_Name = userData['User_name'] as String? ?? '';
    final address = userData['Address'] as String? ?? '';
    final statement = userData['Statement'] as String? ?? '';
    final date = userData['Date'] as String? ?? '';
    final time = userData['Time'] as String? ?? '';
    var approve = userData['Is_Approved'] as bool? ?? false;
    final docId = userData['id'];

    return DataRow(
      cells: [
        DataCell(
          Text(requestId),
        ),
        DataCell(
          Text(userID),
        ),
        DataCell(Text(user_Name)),
        DataCell(
          Center(child: Text(address)),
        ),
        DataCell(
          Text(statement),
        ),
        DataCell(
          Text(date),
        ),
        DataCell(
          Text(time),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () async {
              //print(approve);
              await getUserEmail(userID);
              await getUserName(userID);
              var newApprove = !approve;
              try {
                await getData();

                if (approve == false) {
                  await _firebaseReq.collection('Request').doc(docId).update({
                    'Is_Approved': newApprove,
                  });

                  setState(() {
                    userID_ = userID;
                  });
                  await sendEmail(
                      userName: userName,
                      userMail: userEmail,
                      subject: "Request Approved",
                      message: "Your request has been approved");

                  await getUserAvailable(userID);
                  await updateAvailable();
                  await getUserDocumentId(userID);
                  await Fluttertoast.showToast(
                    msg: "The Request was Successfully Approved!",
                    toastLength: Toast.LENGTH_SHORT, // Duration of the toast
                  );

                  setState(() {
                    approve = true;
                  });
                } else if (approve == true) {
                  await _firebaseReq.collection('Request').doc(docId).update({
                    'Is_Approved': newApprove,
                  });
                  setState(() {
                    approve = false;
                  });
                  // today

                  await sendEmail(
                      userName: userName,
                      userMail: userEmail,
                      subject: "Request Not Accepted",
                      message:
                          "Your request has not been approved. Please try again..");
                  await getUserAvailable(userID);
                  await updateAvailableNotApproved();
                  await getUserDocumentId(userID);
                  //end
                }
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error updating approval: $error'),
                  ),
                );
                print("The error is : $error");
              }
            },
            child: Text(approve ? 'Approved' : 'Not Approved'),
          ),
        ),
      ],
    );
  }

  Future<void> getUserEmail(String userId) async {
    _firebaseReq
        .collection('User')
        .where('User_id', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userEmail = querySnapshot.docs[0]['Email'];
        });
        print(userEmail);
      } else {
        setState(() {
          userEmail = 'Email not found';
        });
        print(userEmail);
      }
    });
  }

  Future<void> getUserAvailable(String userId) async {
    await _firebaseReq
        .collection('User')
        .where('User_id', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userAval = querySnapshot.docs[0]['Available'];
        });
        print(userAval);
      } else {
        setState(() {
          userAval = 'Available value not found';
        });
        print(userAval);
      }
    });
  }

  Future<void> getUserName(String userId) async {
    await _firebaseReq
        .collection('User')
        .where('User_id', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userName = querySnapshot.docs[0]['User name'];
        });
        print(userName);
      } else {
        setState(() {
          userName = 'Available value not found';
        });
        print(userName);
      }
    });
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

  updateAvailable() async {
    try {
      aval = double.parse(userAval);
    } on FormatException {
      print("Error: '$userAval' is not a valid number.");
      // Handle the case where conversion fails (e.g., show error message to user)
      return; // Exit the function if conversion fails
    }

    if (aval != null && aval <= 5) {
      setState(() {
        newAval = aval + 5;
        newAval_D = newAval.toString();
      });

      print("Selected User Id is ${userID_}");

      await updateAvailableField(userID_, newAval_D.toString());
      print("Changed value is ${newAval_D.toString()}");
    }
  }

  Future<void> updateAvailableField(
      String userId, String newAvailableValue) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('User_id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance
            .collection('User')
            .doc(docId)
            .update({'Available': newAvailableValue});

        print('Available field updated successfully');
      } else {
        print('No user found with the given User_id');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found with the given User_id')),
        );
      }
    } catch (e) {
      print('Error updating Available field: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating Available field: $e')),
      );
    }
  }

  Future<void> getUserDocumentId(String requestId) async {
    try {
      // Get the document snapshot for the Request_id
      DocumentSnapshot requestSnapshot = await FirebaseFirestore.instance
          .collection('Request')
          .doc(requestId)
          .get();

      if (requestSnapshot.exists) {
        // Extract the User_id from the Request document
        String userId =
            (requestSnapshot.data() as Map<String, dynamic>)['User_id'];

        // Query the User collection based on User_id
        QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('User_id', isEqualTo: userId)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          // Get the first document (assuming User_id is unique)
          DocumentSnapshot userDocument = userQuerySnapshot.docs.first;
          String userDocumentId = userDocument.id; // Retrieve the document ID
          print('User Document ID: $userDocumentId');
        } else {
          print('User not found for User_id: $userId');
        }
      } else {
        print('Request not found for Request_id: $requestId');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  updateAvailableNotApproved() async {
    try {
      aval = double.parse(userAval);
    } on FormatException {
      print("Error: '$userAval' is not a valid number.");
      // Handle the case where conversion fails (e.g., show error message to user)
      return; // Exit the function if conversion fails
    }

    if (aval != null && aval >= 5) {
      setState(() {
        newAval = aval - 5;
        newAval_D = newAval.toString();
      });

      print("Selected User Id is ${userID_}");

      await updateAvailableField(userID_, newAval_D.toString());
      print("Changed value is ${newAval_D.toString()}");
    }
  }
}
