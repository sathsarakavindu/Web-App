import 'package:cloud_firestore/cloud_firestore.dart';

class Manager {
  String managerId;
  String managerName;

  Manager({
    required this.managerId,
    required this.managerName,
  });

  factory Manager.fromDocument(DocumentSnapshot doc) {
    return Manager(
      managerId: doc['Manager_id'],
      managerName: doc['Manager_name'],
    );
  }
}

class ManagerEdit {
  String managerName;
  String email;
  String password;
  String mobile;
  String epf;
  String nic;
  String address;

  ManagerEdit({
    required this.managerName,
    required this.email,
    required this.password,
    required this.mobile,
    required this.epf,
    required this.nic,
    required this.address,
  });

  factory ManagerEdit.fromDocumentEdit(DocumentSnapshot docEdit) {
    return ManagerEdit(
      managerName: docEdit["Manager_name"],
      email: docEdit["Email"],
      password: docEdit["Password"],
      mobile: docEdit["Mobile"],
      epf: docEdit["EPF"],
      nic: docEdit["NIC"],
      address: docEdit["Address"],
    );
  }
}
