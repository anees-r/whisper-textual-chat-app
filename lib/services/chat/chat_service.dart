import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:textual_chat_app/models/message_model.dart';
import 'package:textual_chat_app/services/requests/requests_service.dart';

class ChatService extends ChangeNotifier {
  // get firestore and auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get all users stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // get non blocked and non deleted users stream
  Stream<List<Map<String, dynamic>>> getUserStreamExcludingBlockedAndDeleted() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection("users")
        .doc(currentUser!.uid)
        .collection("blocked_users")
        .snapshots()
        .asyncMap((snapshot) async {
      // get blocked users id
      final blockedUserIDs = snapshot.docs.map((doc) => doc.id).toList();

      final deletedUsersSnapshot = await _firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("deleted_users")
          .get();
      final deletedUserIDs =
          deletedUsersSnapshot.docs.map((doc) => doc.id).toList();

      // get all users
      final friendSnapshot = await _firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection('friends')
          .get();

      // return as stream list after removing self and blocked users
      return friendSnapshot.docs
          .where((doc) =>
              doc.data()["email"] != currentUser.email &&
              !blockedUserIDs.contains(doc.id) &&
              !deletedUserIDs.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    // get current user
    String currentUserID = _auth.currentUser!.uid;
    String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create new message
    Message newMessage = Message(
        senderId: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // create chatroom and assign unique id
    List<String> ids = [currentUserID, receiverID];
    // ensure both users have same chat room no matter who logs in
    ids.sort();
    String chatRoomId = ids.join("_");

    // creating chatroom document
    await _firestore.collection("chat_room").doc(chatRoomId).set({});

    // save new message to the database
    await _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userId, otherUsersId) {
    // create chatroom id
    List<String> ids = [userId, otherUsersId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // report user
  Future<void> reportUser(String messageID, userID) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageID': messageID,
      'messageOwner': userID,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _firestore.collection("reports").add(report);
  }

  // block user
  Future<void> blockUser(String userID) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection("users")
        .doc(currentUser!.uid)
        .collection("blocked_users")
        .doc(userID)
        .set({});
    notifyListeners();
  }

  // unblock user
  Future<void> unblockUser(String blockedUserID) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection("users")
        .doc(currentUser!.uid)
        .collection("blocked_users")
        .doc(blockedUserID)
        .delete();
  }

  // get blocked users stream
  Stream<List<Map<String, dynamic>>> getBlockedUserStream(String userID) {
    return _firestore
        .collection("users")
        .doc(userID)
        .collection("blocked_users")
        .snapshots()
        .asyncMap((snapshot) async {
      // get list of blocked users ids
      final blockedUsersIDs = snapshot.docs.map((doc) => doc.id).toList();
      // get data of all the blocked users
      final userDocs = await Future.wait(blockedUsersIDs
          .map((id) => _firestore.collection("users").doc(id).get()));
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // delete messages
  Future<void> deleteMessagesFromCurrent() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Get all chat room documents
      QuerySnapshot chatRoomsSnapshot =
          await _firestore.collection('chat_room').get();

      for (var chatRoomDoc in chatRoomsSnapshot.docs) {
        // Access the messages subcollection for each chat room
        QuerySnapshot messagesSnapshot = await _firestore
            .collection('chat_room')
            .doc(chatRoomDoc.id)
            .collection('messages')
            .where('senderId', isEqualTo: _auth.currentUser!.uid)
            .get();

        // Delete each message document that matches the senderId
        for (var messageDoc in messagesSnapshot.docs) {
          await _firestore
              .collection('chat_room')
              .doc(chatRoomDoc.id)
              .collection('messages')
              .doc(messageDoc.id)
              .delete();
          print(
              "Deleted message with ID: ${messageDoc.id} in chat room: ${chatRoomDoc.id}");
        }
      }

      print("Deletion process completed.");
    } catch (e) {
      print("Error deleting messages: $e");
    }
  }

  // delete chat room if the other user is deleted
  Future<void> deleteChatRoom(String userID) async {
    // create chatroom id
    List<String> ids = [userID, _auth.currentUser!.uid];
    ids.sort();
    String chatRoomId = ids.join("_");

    _firestore.collection("chat_room").doc(chatRoomId).delete();
    deleteUser(userID);
    RequestsService().removeFriend(userID);
    notifyListeners();
  }

  // add to deleted user list
  Future<void> deleteUser(String userID) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection("users")
        .doc(currentUser!.uid)
        .collection("deleted_users")
        .doc(userID)
        .set({});
    notifyListeners();
  }

}
