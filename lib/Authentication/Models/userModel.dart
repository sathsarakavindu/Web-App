import 'dart:js_interop';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullName;
  final String email;
  final phoneNo;
  final String password;
  final String epf;
  final String nic;
  final String address;

  const UserModel(/* this.id,*/ {
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNo,
    required this.epf,
    required this.nic,
    required this.address,
  });

  toJson() {
    return {
      "Manager_name": fullName,
      "Email": email,
      "Mobile": phoneNo,
      "Password": password,
      "Address": address,
      "EPF": epf,
      "NIC": nic,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        email: data["Email"],
        password: data["Password"],
        fullName: data["Mnager_name"],
        phoneNo: data["Mobile"],
        epf: data["EPF"],
        nic: data["NIC"],
        address: data["Address"]);
  }
}
