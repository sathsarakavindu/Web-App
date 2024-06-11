import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayDailyQuota extends StatefulWidget {
  const DisplayDailyQuota({super.key});

  @override
  State<DisplayDailyQuota> createState() => _DisplayDailyQuotaState();
}

class _DisplayDailyQuotaState extends State<DisplayDailyQuota> {
  final FirebaseFirestore _firestoreDaily = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return // Assuming you have a StreamBuilder widget to handle data fetching
        StreamBuilder<QuerySnapshot>(
      stream: _firestoreDaily.collection('Daily_Quota').snapshots(),
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
            document['Daily Quota']; // Assuming Daily Quota is a number

        return Text(
          'Daily Quota: $dailyQuota', // Display the value
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold), // Customize text style (optional)
        );
      },
    );
  }
}
