import 'dart:math';

import 'package:admin_web/Pages/Login_page.dart';
import 'package:admin_web/Widgets/Elevated_buttons.dart';
import 'package:admin_web/Widgets/TextWidgets.dart';
import 'package:admin_web/clases/authClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum MyChoice { option1, option2 }

class Reg_page extends StatefulWidget {
  const Reg_page({super.key});

  @override
  State<Reg_page> createState() => _Reg_pageState();
}

class _Reg_pageState extends State<Reg_page> {
  String fullName = "";
  String email = "";
  String password = "";
  String confPassword = "";
  String epf = "";
  String address = "";
  String phone = "";
  String nic = "";
  bool _obscureText = true;
  String confirmError = "";

  final formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final emailRegex = RegExp(r"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$");

  final contactNumberRegex = RegExp(
    r'^[0-9]{10}$',
  );
  final RegExp nameExp = RegExp(r'^[a-zA-Z\s]+$');
  final epfNoRegex = RegExp(
    r'^[0-9]+$',
  );

  void showPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 213, 241),
      body: SafeArea(
        child: Container(
          child: ListView(scrollDirection: Axis.horizontal, children: [
            SingleChildScrollView(
              child: Row(children: [
                Container(
                  width: 480,
                  height: 850,
                  color: Color.fromARGB(255, 166, 224, 251),
                  child: Column(
                    children: [
                      SizedBox(height: 200),
                      Text(
                        "RO Plant",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset("assets/images/ROPlant.jpg"),
                      SizedBox(height: 180),
                      Text(
                        "Developed By Sathsara",
                        style: TextStyle(
                            fontFamily: "Times New Roman",
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    width: 1200,
                    height: 850,
                    color: Color.fromARGB(255, 191, 241, 185),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Registration",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(right: 80),
                          child: SingleChildScrollView(
                            child: Container(
                              width: 600,
                              height: 720,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 246, 231, 248),
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Container(
                                      width: 450,
                                      height: 60,
                                      child: TextWidget(
                                        textLabel: "Enter Full Name",
                                        isPassword: false,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter Your Name";
                                          }
                                          if (!nameExp.hasMatch(value)) {
                                            return "Please enter a valid name.";
                                          }
                                          return null;
                                        },
                                        onSave: (newValue) {
                                          fullName = newValue!;
                                        },
                                        icon: Icon(Icons.person_2_outlined),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 450,
                                      height: 60,
                                      child: TextWidget(
                                          textLabel: "Enter Email",
                                          isPassword: false,
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Enter your email";
                                            }
                                            if (!emailRegex.hasMatch(value)) {
                                              return "Please enter a valid email";
                                            }
                                            return null;
                                          },
                                          onSave: (newValue) {
                                            email = newValue!;
                                          },
                                          icon: Icon(Icons.mail)),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: 450,
                                      height: 60,
                                      child: TextFormField(
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                          labelText: "Enter Password",
                                          icon: Icon(Icons.password),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: showPassword,
                                            icon: Icon(_obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                          ),
                                        ),
                                        obscureText: _obscureText,
                                        validator: (String? value) {
                                          if (value != null) {
                                            if (value.isEmpty) {
                                              return "Enter Your Password";
                                            }
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) {
                                          password = newValue!;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      width: 450,
                                      height: 60,
                                      child: TextFormField(
                                        controller: _confirmPasswordController,
                                        decoration: InputDecoration(
                                          labelText: "Confirm Password",
                                          icon: Icon(Icons.domain_verification),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        obscureText: _obscureText,
                                        validator: (String? value) {
                                          if (value != null) {
                                            if (value.isEmpty) {
                                              return "Confirm Your Password";
                                            }
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) {
                                          confPassword = newValue!;
                                        },
                                      ),
                                    ),
                                    Text(
                                      confirmError,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: 450,
                                      height: 60,
                                      child: TextWidget(
                                        textLabel: "Enter EPF",
                                        isPassword: false,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter Your EPF No";
                                          }
                                          if (!epfNoRegex.hasMatch(value)) {
                                            return "Enter a valid epf no.";
                                          }
                                          return null;
                                        },
                                        onSave: (newValue) {
                                          epf = newValue!;
                                        },
                                        icon: Icon(Icons.person_pin_rounded),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      width: 450,
                                      height: 60,
                                      child: TextWidget(
                                          textLabel: "Enter Address",
                                          isPassword: false,
                                          validator: (String? value) {
                                            if (value != null) {
                                              if (value.isEmpty) {
                                                return "Enter Your Valid Address";
                                              }
                                            }
                                            return null;
                                          },
                                          onSave: (newValue) {
                                            address = newValue!;
                                          },
                                          icon: Icon(Icons.home)),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      width: 450,
                                      height: 60,
                                      child: TextWidget(
                                          textLabel: "Enter Mobile Number",
                                          isPassword: false,
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Enter Your Contact No";
                                            }
                                            if (!contactNumberRegex
                                                .hasMatch(value)) {
                                              return "Please enter a valid contact no";
                                            }
                                            return null;
                                          },
                                          onSave: (newValue) {
                                            phone = newValue!;
                                          },
                                          icon: Icon(Icons.phone)),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      width: 450,
                                      height: 60,
                                      child: TextWidget(
                                          textLabel: "Enter NIC",
                                          isPassword: false,
                                          validator: (String? value) {
                                            if (value != null) {
                                              if (value.isEmpty) {
                                                return "Enter NIC";
                                              }
                                            }
                                            return null;
                                          },
                                          onSave: (newValue) {
                                            nic = newValue!;
                                          },
                                          icon: Icon(
                                              Icons.card_membership_rounded)),
                                    ),
                                    SizedBox(height: 30),
                                    Row(
                                      children: [
                                        SizedBox(width: 160),
                                        SizedBox(
                                          width: 150,
                                          height: 40,
                                          child: Elebutton(
                                              btnColor: Colors.lightBlueAccent,
                                              btnTxt: "Register",
                                              onPressed: () async {
                                                if (formKey.currentState!
                                                        .validate() ==
                                                    false) {
                                                  return;
                                                }

                                                formKey.currentState!.save();

                                                if (checkedPassword() ==
                                                    false) {
                                                  return;
                                                }

                                                try {
                                                  //27/05/2024
                                                  // Check if there is already a manager in the "Manager" collection
                                                  QuerySnapshot querySnapshot =
                                                      await _firestore
                                                          .collection('Manager')
                                                          .get();
                                                  int managerCount =
                                                      querySnapshot.size;
                                                  if (managerCount >= 2) {
                                                    // If there is already a record, show the error message
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text('Error'),
                                                          content: Text(
                                                              'You haven\'t been authorized'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text('OK'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    return;
                                                  }
                                                  //end

                                                  String managerUniqueId =
                                                      generateCustomIDForManager(
                                                          6);

                                                  UserCredential
                                                      userCredential =
                                                      await _auth
                                                          .createUserWithEmailAndPassword(
                                                    email: email,
                                                    password: password,
                                                  );

                                                  String userUid =
                                                      userCredential.user!.uid;

                                                  Map<String, dynamic>
                                                      managerData = {
                                                    "Manager_id":
                                                        managerUniqueId,
                                                    "Manager_name": fullName,
                                                    "Mobile": phone,
                                                    "NIC": nic,
                                                    "Password": password,
                                                    "Email": email,
                                                    "EPF": epf,
                                                    "Address": address,
                                                  };

                                                  await _firestore
                                                      .collection('Manager')
                                                      .doc(userUid)
                                                      .set(managerData);
                                                  print(
                                                      'User created and data saved to Firestore successfully!');

                                                  await Fluttertoast.showToast(
                                                    msg:
                                                        "Successfully Registered!",
                                                    toastLength: Toast
                                                        .LENGTH_SHORT, // Duration of the toast
                                                  );

                                                  Navigator.of(context).pop();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage(),
                                                    ),
                                                  );
                                                } on FirebaseException catch (e) {
                                                  print(
                                                    e.toString(),
                                                  );
                                                }
                                              }),
                                        ),
                                        SizedBox(width: 50),
                                        SizedBox(
                                          width: 150,
                                          height: 40,
                                          child: Elebutton(
                                              btnTxt: "Back",
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage(),
                                                  ),
                                                );
                                              },
                                              btnColor:
                                                  Colors.lightGreenAccent),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ), //
          ]),
        ),
      ),
    );
  }

  String generateCustomIDForManager(int length) {
    const chars = 'MANAGE0123456789';
    Random random = Random();
    String uniqueID = String.fromCharCodes(
      List.generate(
        length,
        (index) => chars.codeUnitAt(
          random.nextInt(chars.length),
        ),
      ),
    );
    return uniqueID;
  }

  checkedPassword() {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        confirmError = "Password do not match";
      });
      return false;
    }
  }
}
