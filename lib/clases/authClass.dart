import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthManagers {
  final FirebaseAuth firebaseAuth_ = FirebaseAuth.instance;

  User? get currentUserState => firebaseAuth_.currentUser;

  Stream<User?> get authStateChange => firebaseAuth_.authStateChanges();

  Future<void> loginWithEmailAndPassword(
      {required email, required password}) async {
    await firebaseAuth_.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUpWithEmailAndPassword(
      {required email, required password}) async {
    await firebaseAuth_.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await firebaseAuth_.signOut();
  }
}
