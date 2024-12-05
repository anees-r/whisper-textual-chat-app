import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // instance of auth
  final FirebaseAuth auth = FirebaseAuth.instance;

  // log in
  Future<UserCredential> loginWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // register
  Future<UserCredential> registerWithEmailPassword(
      String email, password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // log out
  Future<void> logOut() async {
    return await auth.signOut();
  }

  // errors
}
