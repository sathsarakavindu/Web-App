import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestoreDaily = FirebaseFirestore.instance;

class DailyQuotaTable extends StatefulWidget {
  const DailyQuotaTable({super.key});

  @override
  State<DailyQuotaTable> createState() => _DailyQuotaTableState();
}

class _DailyQuotaTableState extends State<DailyQuotaTable> {
  Stream<QuerySnapshot> _queryStream =
      _firestoreDaily.collection('Daily_Quota').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _queryStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something Went Wrong. ${snapshot}");
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final _QuotaData = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>; // Cast data to Map
            return data;
          }).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          "Daily Quota",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Time",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ],
                    rows: _QuotaData.map(
                            (userData) => createDataRowDailyQuota(userData))
                        .toList(),
                  ),
                ]),
          );
        });
  }

  DataRow createDataRowDailyQuota(Map<String, dynamic> userData) {
    final dailyQ = userData['Daily Quota'] as String? ?? '';
    final time = userData['Time'] as String? ?? '';
    final date = userData['Date'] as String? ?? '';

    return DataRow(
      cells: [
        DataCell(Text(
          dailyQ,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        )),
        DataCell(Text(
          time,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        )),
        DataCell(
          Text(
            date,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
