import 'package:admin_web/Pages/Dashboard.dart';
import 'package:admin_web/Pages/Register_page.dart';
import 'package:admin_web/Pages/dash.dart';
import 'package:admin_web/Pages/forgotPasswordPage.dart';
import 'package:admin_web/Pages/home_dashboard.dart';
import 'package:admin_web/Widgets/Elevated_buttons.dart';
import 'package:admin_web/Widgets/TextWidgets.dart';
import 'package:admin_web/clases/authClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String email_ = "";
  String password_ = "";
  String err = "";
  String currentEmail = "";
  String currentPassword = "";

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<bool> loginManager(String email, String password) async {
    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // If login successful, check if user exists in Manager collection
      DocumentSnapshot managerDoc = await _firestore
          .collection('Manager')
          .doc(userCredential.user!.uid)
          .get();

      if (managerDoc.exists) {
        // User exists in Manager collection, login successful
        return true;
      } else {
        // User exists with email/password but not in Manager collection
        // (handle this scenario as needed, e.g., log out or display an error)
        await _auth.signOut(); // Consider logging out for security
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that email.');
        return false;
      } else {
        print(e.code);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateFirestorePassword(String email, String newPassword) async {
    try {
      // Update Firebase Authentication password
      await _auth.currentUser!.updatePassword(newPassword);

      // Update Firestore "Manager" table password field
      QuerySnapshot querySnapshot = await _firestore
          .collection('Manager')
          .where('Email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String managerId = querySnapshot.docs.first.id;
        await _firestore.collection('Manager').doc(managerId).update({
          'Password': newPassword,
        });
        print(managerId);
        print('Firestore password updated successfully');
      }
    } catch (e) {
      print('Error updating password in Firestore: $e');
    }
  }

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
            currentEmail = data['Email'] ?? '';

            currentPassword = data['Password'] ?? '';
          });
          print(currentEmail);
          print(currentPassword);
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

  void _handleError(FirebaseAuthException e) {
    String message = "";
    switch (e.code) {
      case "invalid-email":
        // message = "Please enter a valid email address.";
        break;
      case "user-not-found":
        message = "The email address is not associated with an account.";
        break;
      default:
        message = "An error occurred. Please try again later.";
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String hashPassword(String password) {
    // Implement your secure password hashing logic here
    // (e.g., using a library like `dart_pbkdf2`)
    // Replace with your actual implementation
    return 'hashed_password'; // Placeholder
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 167, 221, 246),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Container(
                      height: 500,
                      width: 460,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 209, 252, 211),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Welcome",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 50),
                          Container(
                            width: 400,
                            height: 70,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "Enter Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  icon: Icon(Icons.person)),
                              validator: (String? value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return "Enter Valid Email";
                                  }
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                email_ = newValue!;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 400,
                            height: 70,
                            child: TextFormField(
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: "Enter Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: _togglePasswordVisibility,
                                  icon: Icon(_obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                icon: Icon(Icons.password),
                              ),
                              validator: (String? value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return "Enter Valid Password";
                                  }
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                password_ = newValue!;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${err}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 15),
                          ),
                          SizedBox(height: 15),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "Forget Password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordPage(),
                                      ),
                                    );
                                  },
                              ),
                            ]),
                          ),
                          SizedBox(height: 30),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Create Account",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Reg_page(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 140,
                            height: 45,
                            child: Elebutton(
                              btnColor: Colors.lightBlueAccent,
                              btnTxt: "Login",
                              onPressed: () async {
                                if (formKey.currentState!.validate() == false) {
                                  return;
                                }
                                formKey.currentState!.save();

                                try {
                                  bool isManagerLoggedIn =
                                      await loginManager(email_, password_);

                                  if (isManagerLoggedIn) {
                                    print(
                                        'Login successful! User is a manager.');

                                    await fetchUserData();

                                    if (currentPassword != password_) {
                                      await updateFirestorePassword(
                                          email_, password_);
                                    }

                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Dashboard_page(),
                                      ),
                                    );
                                  } else {
                                    print(
                                        'Login failed or user is not a manager.');
                                  }
                                  setState(() {
                                    err = "Invalid Email and Password";
                                  });
                                } on FirebaseException catch (e) {
                                  setState(() {
                                    err = "Invalid Email or Password";
                                  });
                                  print("Login error is ${e.toString()}");
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
