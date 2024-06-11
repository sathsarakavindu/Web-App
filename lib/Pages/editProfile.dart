import 'dart:js_interop';

import 'package:admin_web/Widgets/Elevated_buttons.dart';
import 'package:admin_web/Widgets/Navigation_drawer_widget.dart';
import 'package:admin_web/Widgets/TextWidgets.dart';
import 'package:admin_web/Widgets/appBars.dart';
import 'package:admin_web/Widgets/editManagerData.dart';
import 'package:admin_web/clases/Manager.dart';
import 'package:admin_web/clases/ManagerService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Edit_Profile extends StatefulWidget {
  const Edit_Profile({super.key});

  @override
  State<Edit_Profile> createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = "";
  String _epf = "";
  String _email = "";
  String _address = "";
  String _contactNumber = "";
  String _newEmail = "";
  String _nic = "";
  String _password = "";
  String _newPassword = "";
  String _save = "";
  String _cancel = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _dataFetched = false;
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final contactNumberRegex = RegExp(
    r'^[0-9]{10}$',
  );
  final RegExp nameExp = RegExp(r'^[a-zA-Z\s]+$');
  final epfNoRegex = RegExp(
    r'^[0-9]+$',
  );

  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    try {
      if (user != null) {
        DocumentSnapshot userData =
            await _firestore.collection('Manager').doc(user?.uid).get();
        if (userData.exists) {
          print("Data exists named manager");
          Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
          setState(() {
            _fullName = data['Manager_name'] ?? '';
            _address = data['Address'] ?? '';
            _contactNumber = data['Mobile'] ?? '';
            _email = data['Email'] ?? '';
            _epf = data['EPF'] ?? '';
            _password = data['Password'] ?? '';
            _nic = data['NIC'] ?? '';
            _dataFetched = true;
          });
        } else {
          print("No exists");
        }
      } else {
        print("User is Null");
      }
    } catch (e) {
      print("Loading profile error is ${e.toString()}");
    }
  }

  Future<void> updateUserData() async {
    User? user = _auth.currentUser;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final docRef =
            FirebaseFirestore.instance.collection('Manager').doc(user?.uid);
        await docRef.update({
          'Manager_name': _fullName,
          'Email': _newEmail,
          'Password': _newPassword,
          'Address': _address,
          'Mobile': _contactNumber,
          'EPF': _epf,
          'NIC': _nic,
        });

        if (_newEmail != user!.email) {
          await user.verifyBeforeUpdateEmail(_newEmail);
          await user.sendEmailVerification();
          print(_newEmail);
        }

        if (_password != _newPassword) {
          if (_password.isNotEmpty) {
            await user.updatePassword(_newPassword);
            print(_newPassword);
          }
        }
        await Fluttertoast.showToast(
          msg: "The Data was Successfully Updated!",
          toastLength: Toast.LENGTH_SHORT, // Duration of the toast
        );
      } on FirebaseException catch (e) {
        print("Your error : " + e.toString());
      }
      // Handle successful update (e.g., show a snackbar)
    }
  }

  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: appBars(appBarTitle: "Edit Profile"),
        ),
      ),
      body: _dataFetched //started
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.all(70),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: 1100,
                    height: 550,
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Color.fromARGB(255, 215, 238, 189),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        buildNameFields(),
                        SizedBox(height: 20),
                        buildEmailField(),
                        SizedBox(height: 20),
                        buildAddressAndMobileFields(),
                        SizedBox(height: 20),
                        buildEPFAndNIC(),
                        SizedBox(height: 50),
                        buildCancelAndSave(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                "Waiting..",
                style: TextStyle(color: Colors.red),
              ),
            ),
    );
  }

  Widget buildNameFields() {
    return Row(
      children: [
        Flexible(
          flex: 5,
          child: SizedBox(
            width: 500.0,
            child: TextFormField(
              initialValue: _fullName,
              decoration: InputDecoration(
                  labelText: "Enter New Name",
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  iconColor: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Full name';
                }
                if (!nameExp.hasMatch(value)) {
                  return "Invalid name";
                }
                return null;
              },
              onSaved: (value) => _fullName = value!,
            ),
          ),
        ),
        SizedBox(width: 50.0),
        Flexible(
          flex: 5,
          child: SizedBox(
            width: 500,
            child: TextFormField(
              initialValue: _email,
              decoration: InputDecoration(
                  labelText: "Enter New Email",
                  icon: Icon(Icons.email_sharp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  //  hintText: "Email Address",
                  iconColor: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Email';
                }
                if (!emailRegex.hasMatch(value)) {
                  return "Invalid Email";
                }
                return null;
              },
              onSaved: (value) => _newEmail = value!,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEmailField() {
    return Row(
      children: [
        Flexible(
          child: SizedBox(
            width: 500.0,
            child: TextFormField(
              obscureText: _obscureText,
              initialValue: _password,
              decoration: InputDecoration(
                labelText: "Enter New Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                ),
                icon: Icon(Icons.password),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Password';
                }
                return null;
              },
              onSaved: (value) => _newPassword = value!,
            ),
          ),
        ),
        SizedBox(
          width: 50,
        ),
        Flexible(
          child: SizedBox(
            width: 500.0,
            child: TextFormField(
              initialValue: _address,
              decoration: InputDecoration(
                  labelText: "Enter New Address",
                  icon: Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  iconColor: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Valid Address';
                }
                return null;
              },
              onSaved: (value) => _address = value!,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAddressAndMobileFields() {
    return Row(
      children: [
        Flexible(
          child: SizedBox(
            width: 500,
            child: TextFormField(
              initialValue: _contactNumber,
              decoration: InputDecoration(
                  labelText: "Enter New Contact No",
                  icon: Icon(Icons.contact_phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  iconColor: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Mobile No';
                }
                if (!contactNumberRegex.hasMatch(value)) {
                  return "Invalid Mobile No";
                }
                return null;
              },
              onSaved: (value) => _contactNumber = value!,
            ),
          ),
        ),
        SizedBox(
          width: 50,
        ),
        Flexible(
          child: SizedBox(
            width: 500.0,
            child: TextFormField(
              initialValue: _epf,
              decoration: InputDecoration(
                  labelText: "Enter New EPF",
                  icon: Icon(Icons.person_pin_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  iconColor: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your EPF';
                }
                if (!epfNoRegex.hasMatch(value)) {
                  return "Invalid epf";
                }
                return null;
              },
              onSaved: (value) => _epf = value!,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEPFAndNIC() {
    return Row(
      children: [
        Flexible(
          child: SizedBox(
            width: 460,
            child: TextFormField(
              initialValue: _nic,
              decoration: InputDecoration(
                  labelText: "Enter New NIC",
                  icon: Icon(Icons.card_membership_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  iconColor: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your NIC';
                }
                return null;
              },
              onSaved: (value) => _nic = value!,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCancelAndSave() {
    return Row(
      children: [
        SizedBox(
          width: 40,
        ),
        Flexible(
          child: SizedBox(
            width: 130.0,
            height: 40,
            child: Elebutton(
              btnTxt: "Cancel",
              onPressed: () {},
              btnColor: Color.fromARGB(255, 236, 191, 252),
            ),
          ),
        ),
        SizedBox(width: 25.0),
        Flexible(
          child: SizedBox(
            width: 130,
            height: 40,
            child: Elebutton(
                btnTxt: "Save",
                onPressed: () async {
                  await updateUserData();

                  print(_fullName);
                  print(_email);
                  print(_password);
                },
                btnColor: Colors.lightBlueAccent),
          ),
        ),
      ],
    );
  }
}
