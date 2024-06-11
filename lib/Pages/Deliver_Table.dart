import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestoreDeliver = FirebaseFirestore.instance;

class DeliverTable extends StatefulWidget {
  const DeliverTable({super.key});

  @override
  State<DeliverTable> createState() => _DeliverTableState();
}

class _DeliverTableState extends State<DeliverTable> {
  Stream<QuerySnapshot> _streamDeliver =
      _firestoreDeliver.collection('Deliver').snapshots();
  TextEditingController _filterController = TextEditingController();
  String _filter = "";

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
            "Deliver Table",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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
            child: TextFormField(
              controller: _filterController,
              decoration: InputDecoration(
                labelText:
                    'Filter by Deliver Id, Order Id, User Id, or Driver Id',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Expanded(
          child: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
              stream: _streamDeliver,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error : ${snapshot.error}");
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final _DeliverData = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {'id': doc.id, ...data};
                }).toList();

                final filteredData = _DeliverData.where((element) {
                  final deliverId = element['Deliver_Id'] as String? ?? '';
                  final orderId = element['Order_Id'] as String? ?? '';
                  final userId = element['User_Id'] as String? ?? '';
                  final driverId = element['Driver_Id'] as String? ?? '';
                  final filter = _filter.toLowerCase();

                  return deliverId.toLowerCase().contains(filter) ||
                      orderId.toLowerCase().contains(filter) ||
                      userId.toLowerCase().contains(filter) ||
                      driverId.toLowerCase().contains(filter);
                }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          "Deliver Id",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Order Id",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "User Id",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Driver Id",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Quantity",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Time",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Date",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: filteredData
                        .map((userData) => createDataRowDeliver(userData))
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

  DataRow createDataRowDeliver(Map<String, dynamic> userData) {
    final deliverId = userData['Deliver_Id'] as String? ?? 'Unknown';
    final orderId = userData['Order_Id'] as String? ?? '';
    final userId = userData['User_Id'] as String? ?? '';
    final driverId = userData['Driver_Id'] as String? ?? '';
    final quantity = userData['Quantity'] as String? ?? '';
    final time = userData['Time'] as String? ?? '';
    final date = userData['Date'] as String? ?? '';
    var delivered = userData['Is_Delivered'] as bool? ?? false;

    return DataRow(
      cells: [
        DataCell(
          Text(deliverId),
        ),
        DataCell(
          Text(orderId),
        ),
        DataCell(Text(userId)),
        DataCell(
          Text(driverId),
        ),
        DataCell(
          Text(quantity),
        ),
        DataCell(
          Text(time),
        ),
        DataCell(
          Text(date),
        ),
      ],
    );
  }
}
