import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // instance of auth
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser(){
    return auth.currentUser;
  }

  // log in
  Future<UserCredential> loginWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // save user data in separate document of users collection
      _firestore.collection("users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        }
      );

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

      // save user data in separate document of users collection
      _firestore.collection("users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        }
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }

  }

  // log out
  Future<void> logOut() async {
    return await auth.signOut();
  }

  // delete account
  // Future<void> deleteAccount() async{
  //   await auth.currentUser!.delete();
  //   await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).delete();
  //   return;
  // }
}
