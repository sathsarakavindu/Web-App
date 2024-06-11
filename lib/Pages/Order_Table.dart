import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestoreOrder = FirebaseFirestore.instance;

class Order_Table extends StatefulWidget {
  const Order_Table({super.key});

  @override
  State<Order_Table> createState() => _Order_TableState();
}

class _Order_TableState extends State<Order_Table> {
  Stream<QuerySnapshot> _streamOrder =
      _firestoreOrder.collection('Order').snapshots();
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
            "Order Table",
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
            width: 350,
            child: TextFormField(
              controller: _filterController,
              decoration: InputDecoration(
                labelText: 'Filter by Order Id or User Id',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
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
              stream: _streamOrder,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final _OrderData = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {'id': doc.id, ...data};
                }).toList();

                final filteredData = _OrderData.where((element) {
                  final orderId = element['Order_Id'] as String? ?? '';
                  final userId = element['User_Id'] as String? ?? '';
                  final filter = _filter.toLowerCase();

                  return orderId.toLowerCase().contains(filter) ||
                      userId.toLowerCase().contains(filter);
                }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
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
                          "Unit Price",
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
                      DataColumn(
                        label: Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: filteredData
                        .map((userData) => createDataRowOrder(userData))
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

  DataRow createDataRowOrder(Map<String, dynamic> userData) {
    final orderId = userData['Order_Id'] as String? ?? 'Unknown';
    final userId = userData['User_Id'] as String? ?? '';
    final unitPrice = userData['Unit_Price'] as String? ?? '';
    final quantity = userData['Quantity'] as String? ?? '';
    final time = userData['Time'] as String? ?? '';
    final date = userData['Date'] as String? ?? '';
    final total = userData['Total'] as String? ?? '';

    return DataRow(
      cells: [
        DataCell(
          Text(orderId),
        ),
        DataCell(
          Text(userId),
        ),
        DataCell(Text(unitPrice)),
        DataCell(
          Text(quantity),
        ),
        DataCell(
          Text(time),
        ),
        DataCell(
          Text(date),
        ),
        DataCell(
          Text(total),
        ),
      ],
    );
  }
}
