import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PriceDisplay extends StatefulWidget {
  const PriceDisplay({super.key});

  @override
  State<PriceDisplay> createState() => _PriceDisplayState();
}

class _PriceDisplayState extends State<PriceDisplay> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Price').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return Text('Loading...');
        }

        // Access data from the first document (assuming a single daily quota)
        DocumentSnapshot document = snapshot.data!.docs.first;
        String dailyQuota =
            document['Price']; // Assuming Daily Quota is a number

        return Text(
          'Price of 1 Liter : $dailyQuota', // Display the value
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold), // Customize text style (optional)
        );
      },
    );
  }
}
