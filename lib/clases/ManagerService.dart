import 'package:admin_web/clases/Manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManagerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Manager?> getLoggedInManager() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return null;
    }
    print("_Current user is not null");

    final docRef = _firestore.collection('Manager').doc(currentUser.uid);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      print("The current data was founded..");
      return Manager.fromDocument(docSnapshot);
    } else {
      print("The current user can't be found");
      print("CurrentUser.uid : ${currentUser.uid}");
      return null;
    }
  }
}

class ManagerServiceEdit {
  final FirebaseFirestore _firestoreEdit = FirebaseFirestore.instance;
  final FirebaseAuth _authEdit = FirebaseAuth.instance;

  Future<ManagerEdit?> getLoggedInManagerEdit() async {
    final currentUserEdit = _authEdit.currentUser;
    if (currentUserEdit == null) {
      print("User is null");
      return null;
    }
    print("_Current user is not null");

    final docRefEdit =
        _firestoreEdit.collection('Manager').doc(currentUserEdit.uid);
    final docSnapshotEDit = await docRefEdit.get();

    if (docSnapshotEDit.exists) {
      print("The current data was founded");
      return ManagerEdit.fromDocumentEdit(docSnapshotEDit);
    } else {
      print("The current user can't be found");
      print("CurrentUser.uid : ${currentUserEdit.uid}");
      return null;
    }
  }
}
