import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:textual_chat_app/services/chat/chat_service.dart';

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
  Future<String> sendRequest(String receiverEmail) async {
    String senderID = _auth.currentUser!.uid;
    String senderEmail = _auth.currentUser!.email!;
    String receiverID = await getUidByEmail(receiverEmail);
    print("receiver id: $receiverID");

    // If the user exists, proceed
    if (receiverID.isNotEmpty) {
      // check if already friends
      QuerySnapshot existingFriend = await _firestore
          .collection('users')
          .doc(senderID)
          .collection('friends')
          .where('uid', isEqualTo: receiverID)
          .where('email', isEqualTo: receiverEmail)
          .get();

      if (existingFriend.docs.isEmpty) {
        // Check if a request already exists between the sender and receiver
        QuerySnapshot existingRequest = await _firestore
            .collection('users')
            .doc(receiverID)
            .collection('requests')
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

          await _firestore
              .collection('users')
              .doc(receiverID)
              .collection('requests')
              .add(requestData);
          return "Request sent successfully!";
        } else {
          // Request already exists
          return "Request already exists!";
        }
      } else {
        //friend already exists
        return "Already friends with this whisperer!";
      }
    }
    return "Could not send request!";
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
      final userDocs = await Future.wait(
          senderIDs.map((id) => _firestore.collection("users").doc(id).get()));
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // accept request
  Future<void> acceptRequest(String senderID, senderEmail) async {
    String currentUserID = _auth.currentUser!.uid;
    String currentUserEmail = _auth.currentUser!.email!;

    // add sender's id and email to current user's friends
    Map<String, dynamic> friendData1 = {
      'uid': senderID,
      'email': senderEmail,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(currentUserID)
        .collection('friends')
        .doc(senderID)
        .set(friendData1);

    // add current user's id and email to sender's friends
    Map<String, dynamic> friendData2 = {
      'uid': currentUserID,
      'email': currentUserEmail,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(senderID)
        .collection('friends')
        .doc(currentUserID)
        .set(friendData2);

    // remove friend request from requests collection
    removeRequest(senderID, senderEmail, currentUserID);

    // create chatroom between request sender and current user
    ChatService().createChatRoom(senderID);

    // notify listeners
    notifyListeners();
  }

  // reject request
  Future<void> rejectRequest(String senderID, senderEmail) async {
    String currentUserID = _auth.currentUser!.uid;

    // remove request from request's collection
    removeRequest(senderID, senderEmail, currentUserID);

    // notify listeners
    notifyListeners();
  }

  // remove request
  Future<void> removeRequest(
      String senderID, senderEmail, currentUserID) async {
    // remove request from request's collection
    QuerySnapshot fetchedRequest = await _firestore
        .collection('users')
        .doc(currentUserID)
        .collection('requests')
        .where('senderID', isEqualTo: senderID)
        .where('senderEmail', isEqualTo: senderEmail)
        .get();

    // looping and removing request
    for (var doc in fetchedRequest.docs) {
      await doc.reference.delete();
    }
  }

  // remove friends
  Future<void> removeFriend(String userID) async {
    // fetch friend from friends
    QuerySnapshot friendSnapshot1 = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('friends')
        .where('uid', isEqualTo: userID)
        .get();
    // delete that friend
    for (var doc in friendSnapshot1.docs) {
      doc.reference.delete();
    }

    // create chatroom id
    List<String> ids = [userID, _auth.currentUser!.uid];
    ids.sort();
    String chatRoomId = ids.join("_");

    // update chatroom status
    await _firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .update({'removed': true});
  }

  // get requests count
  Stream<int> getRequestsCount() {
    String currentUserID = _auth.currentUser!.uid;

    return _firestore
        .collection('users')
        .doc(currentUserID)
        .collection('requests')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
}
