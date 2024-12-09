import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestsService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get uid on the basis of email
  Future<String> getUidByEmail(String receiverEmail) async {
    // Query Firestore collection "users" where email matches receiverEmail
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: receiverEmail)
        .get();

    // Check if a user with the matching email exists
    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the UID of the first matched document
      return querySnapshot.docs.first.id;
    } else {
      print('No user found with the given email.');
      return "";
    }
  }

  // send request
  Future<void> sendRequest(String receiverEmail) async {
    String senderID = _auth.currentUser!.uid;
    String senderEmail = _auth.currentUser!.email!;
    String receiverID = await getUidByEmail(receiverEmail);
    print("receiver id: $receiverID");
    // If the user exists, proceed
    if (receiverID.isNotEmpty) {
      // Check if a request already exists between the sender and receiver
      QuerySnapshot existingRequest = await _firestore
          .collection('users').doc(receiverID).collection('requests')
          .where('senderID', isEqualTo: senderID)
          .where('senderEmail', isEqualTo: senderEmail)
          .get();

      if (existingRequest.docs.isEmpty) {
        // No existing request, so create a new one
        Map<String, dynamic> requestData = {
          'senderID': senderID,
          'senderEmail': senderEmail,
          'timestamp': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('users').doc(receiverID).collection('requests').add(requestData);
        print("Request sent successfully!");
      } else {
        // Request already exists
        print("Request already exists between $senderID and $receiverID.");
      }
    }
  }

  // get requests
  
  Stream<List<Map<String, dynamic>>> getRequests(String userID) {
    return _firestore
        .collection("users")
        .doc(userID)
        .collection("requests")
        .snapshots()
        .asyncMap((snapshot) async {
      // get list of blocked users ids
      final senderIDs = snapshot.docs
          .map((doc) => doc.data()['senderID'] as String?)
          .toList();

      // Fetch user data for each sender ID
      final userDocs = await Future.wait(senderIDs
          .map((id) => _firestore.collection("users").doc(id).get()));
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // accept request

  // reject request
}
