import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:textual_chat_app/services/chat/chat_service.dart';

class AuthService {
  // instance of auth
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser() {
    return auth.currentUser;
  }

  // log in
  Future<UserCredential> loginWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // save user data in separate document of users collection
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

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
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

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
  Future<void> deleteAccount() async {
    // delete messages all the messages by current user
    ChatService().deleteMessagesFromCurrent();

    // change email of current user to Deleted account
    _firestore.collection("users").doc(auth.currentUser!.uid).update({'email': 'Deleted Account'});

    // delete all reports about current user
    QuerySnapshot reportedMessages = await _firestore.collection('reports').where('messageOwner', isEqualTo: auth.currentUser!.uid).get();
    // loop all reports and delete
    for(var doc in reportedMessages.docs){
      doc.reference.delete();
    }

    // delete current user from authentication
    auth.currentUser!.delete();
  }
}
