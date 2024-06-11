import 'package:admin_web/Pages/Dashboard.dart';
import 'package:admin_web/Pages/Login_page.dart';
import 'package:admin_web/Pages/dash.dart';
import 'package:admin_web/Pages/editProfile.dart';
import 'package:admin_web/Pages/home_dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase
        .initializeApp(); // correctly initialize your apiKey, appId, messagindSenderId and projectId
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
