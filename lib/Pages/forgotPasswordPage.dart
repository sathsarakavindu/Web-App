import 'package:admin_web/Pages/Login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String error = "";
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String newMail = "";
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 149, 206, 253),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              width: 30,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                weight: 1000,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "Back",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 550),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Receive you entered email to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 400,
                child: TextFormField(
                  controller: _emailController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    if (value != null) {
                      if (emailRegex.hasMatch(value) == false) {
                        return "Enter Valid Email";
                      }
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    newMail = newValue!;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "${error}",
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: 260,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (formKey.currentState!.validate() == false) {
                      return;
                    }

                    formKey.currentState!.save();

                    if (await checkEmailExists(newMail) == true) {
                      await _resetPassword();

                      await Fluttertoast.showToast(
                        msg: "A verification was sent your email account",
                        toastLength:
                            Toast.LENGTH_SHORT, // Duration of the toast
                      );

                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    } else {
                      setState(() {
                        error = "There isn't an account from this email";
                      });
                      return;
                    }
                  },
                  icon: Icon(Icons.mail),
                  label: Text(
                    "Reset Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    try {
      // Send password reset email

      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());

      User? user = _auth.currentUser;
      String? newPassword = user?.email ?? '';

      // Show success message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Success'),
          content: Text('Password reset email sent.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
      // Get the new password from Firebase Authentication
    } catch (e) {
      // Show error message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to reset password. ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Manager')
          .where('Email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking email existence: $e');
      return false;
    }
  }
}
