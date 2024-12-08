import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:textual_chat_app/models/message_model.dart';

class ChatService {
  // get firestore and auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
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

    // save new message to the database
    await _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());    
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userId, otherUsersId){
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


}
