import 'dart:js_interop';
import 'package:http/http.dart' as http;
import 'package:admin_web/Pages/Login_page.dart';
import 'package:admin_web/clases/authClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;

class appBars extends StatefulWidget {
  String appBarTitle = "";

  appBars({super.key, required this.appBarTitle});

  @override
  State<appBars> createState() => _appBarsState();
}

class _appBarsState extends State<appBars> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime nowTime = DateTime.now();
  DateTime now = DateTime.now();

  Future<void> generateAndDownloadPdfReport() async {
    try {
      // Fetch data from Firestore
      DateTime now = DateTime.now();
      String formattedTime = now.toString().substring(11, 16);

      String formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      QuerySnapshot querySnapshot =
          await _firestore.collection('Total_Price').get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      // Sort documents by 'Date' field in ascending order
      documents.sort((a, b) {
        Map<String, dynamic> dataA = a.data() as Map<String, dynamic>;
        Map<String, dynamic> dataB = b.data() as Map<String, dynamic>;
        return dataA['Date'].compareTo(dataB['Date']);
      });

      double totalValue = 0;
      for (var doc in documents) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('Total') && data['Total'] is String) {
          try {
            totalValue += double.parse(data['Total']);
          } catch (e) {
            print(
                "Error parsing Total value: ${data['Total']} - ${e.toString()}");
          }
        }
      }

      // Create a new PDF document
      final pdf = pw.Document();

      // Add a page with a table to the PDF document
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(
                  "Monthly Income Report",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                  'Date: $formattedDate',
                  style: pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Time: $formattedTime',
                  style: pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['Date', 'Time', 'Order Id', 'Amount'],
                  data: documents.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return [
                      data['Date'],
                      data['Time'],
                      data['Id'],
                      data['Total'],
                    ];
                  }).toList(),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Total Value: \Rs ${totalValue.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.red),
                ),
              ],
            );
          },
        ),
      );

      // Save and download the PDF document
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'Total_Price_Report.pdf',
      );
    } catch (e) {
      print("Report error: ${e.toString()}");
    }
  }

  Future<void> generateAndDownloadWaterUsagePdfReport() async {
    try {
      // Fetch data from Firestore

      String formattedTime = nowTime.toString().substring(11, 16);

      String formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      QuerySnapshot querySnapshot =
          await _firestore.collection('water_usage').get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      double totalValue = documents.fold(0, (sum, doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return sum + double.parse(data['Amount']);
      });

      // Sort documents by 'Date' field in ascending order
      documents.sort((a, b) {
        Map<String, dynamic> dataA = a.data() as Map<String, dynamic>;
        Map<String, dynamic> dataB = b.data() as Map<String, dynamic>;
        return dataA['Date'].compareTo(dataB['Date']);
      });

      // Create a new PDF document
      final pdf = pw.Document();

      // Add a page with a table to the PDF document
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(
                  "Monthly Water Usage Report",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                  'Date: ${formattedDate}',
                  style: pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Time: ${formattedTime}',
                  style: pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['Date', 'Time', 'User Id', 'Amount (Liters)'],
                  data: documents.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return [
                      data['Date'],
                      data['Time'],
                      data['User_id'],
                      data['Amount'],
                    ];
                  }).toList(),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Monthly Water Usage: ${totalValue.toStringAsFixed(2)} Liters',
                  style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.red),
                ),
              ],
            );
          },
        ),
      );

      // Save and download the PDF document
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'Total_Water_Usage_Report.pdf',
      );
    } catch (e) {
      Text("Report error: ${e.toString()}");
      print(e.toString());
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog on Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuthManagers().signOut(); // Sign out user
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
                // Dismiss dialog on OK
                // Optionally, navigate to a login screen here
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromARGB(255, 247, 244, 99),
      title: Text(
        widget.appBarTitle,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () async {
            await generateAndDownloadWaterUsagePdfReport();
          },
          icon: Icon(
            Icons.water_drop_rounded,
          ),
        ),
        Text("Monthly Water Usage"),
        SizedBox(
          width: 20,
        ),
        IconButton(
          onPressed: () async {
            await generateAndDownloadPdfReport();
          },
          icon: Icon(
            Icons.download,
          ),
        ),
        Text("Monthly Income"),
        SizedBox(
          width: 20,
        ),
        IconButton(
          color: Colors.black,
          onPressed: _showLogoutDialog,
          icon: Icon(Icons.logout_sharp),
        ),
        Text(
          "Log out",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
