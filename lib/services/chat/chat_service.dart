import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:textual_chat_app/models/message_model.dart';
import 'package:textual_chat_app/services/requests/requests_service.dart';
import 'package:rxdart/rxdart.dart';

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

    // Listen to changes in blocked users
    final blockedStream = _firestore
        .collection("users")
        .doc(currentUser!.uid)
        .collection("blocked_users")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

    // Listen to changes in deleted users
    final deletedStream = _firestore
        .collection("users")
        .doc(currentUser.uid)
        .collection("deleted_users")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

    // Combine the streams of blocked and deleted users
    return Rx.combineLatest2<List<String>, List<String>, List<String>>(
      blockedStream,
      deletedStream,
      (blockedUserIDs, deletedUserIDs) => blockedUserIDs + deletedUserIDs,
    ).switchMap((excludedUserIDs) {
      // Listen to changes in friends and filter out excluded users
      return _firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("friends")
          .snapshots()
          .map((friendSnapshot) {
        return friendSnapshot.docs
            .where((doc) =>
                doc.data()["email"] != currentUser.email &&
                !excludedUserIDs.contains(doc.id))
            .map((doc) => doc.data())
            .toList();
      });
    });
  }

  // create a chat room
  Future<void> createChatRoom(String requesterID) async {
    String currentUserID = _auth.currentUser!.uid;

    // create chatroom and assign unique id
    List<String> ids = [currentUserID, requesterID];
    // ensure both users have same chat room no matter who logs in
    ids.sort();
    String chatRoomId = ids.join("_");

    // creating chatroom map
    Map<String, dynamic> chatroomData = {
      'user1': currentUserID,
      'user2': requesterID,
      'removed': false,
      'blockedby': "",
      'unreaduser1': 0,
      'unreaduser2': 0,
    };

    // creating chatroom document
    await _firestore.collection("chat_room").doc(chatRoomId).set(chatroomData);
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    // get current user
    String currentUserID = _auth.currentUser!.uid;
    String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create chatroomid
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomId = ids.join("_");

    // create new message
    Message newMessage = Message(
        senderId: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // save new message to the database
    await _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());

    // get chatroom document
    DocumentSnapshot chatroomSnapshot =
        await _firestore.collection('chat_room').doc(chatRoomId).get();
    if (chatroomSnapshot.exists) {
      final data = chatroomSnapshot.data() as Map<String, dynamic>;

      // store unread message count based on sender
      if (data['user1'] == currentUserID) {
        final count = data['unreaduser2'];
        await _firestore
            .collection('chat_room')
            .doc(chatRoomId)
            .update({'unreaduser2': count + 1});
      } else {
        final count = data['unreaduser1'];
        await _firestore
            .collection('chat_room')
            .doc(chatRoomId)
            .update({'unreaduser1': count + 1});
      }
    }
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

  // mark as read
  Future<void> markRead(String userId, otherUsersId) async {
    List<String> ids = [userId, otherUsersId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // mark messages as read
    DocumentSnapshot chatroomSnapshot =
        await _firestore.collection('chat_room').doc(chatRoomId).get();
    if (chatroomSnapshot.exists) {
      final data = chatroomSnapshot.data() as Map<String, dynamic>;

      // update unread message count based on sender
      if (data['user1'] == _auth.currentUser!.uid) {
        _firestore
            .collection('chat_room')
            .doc(chatRoomId)
            .update({'unreaduser1': 0});
      } else {
        _firestore
            .collection('chat_room')
            .doc(chatRoomId)
            .update({'unreaduser2': 0});
      }
    }
  }

  // check blocked and removed friend status
  Future<String> checkRemovedAndBlocked(String userId) async {
    String currentUserID = _auth.currentUser!.uid;
    List<String> ids = [userId, currentUserID];
    ids.sort();
    String chatRoomId = ids.join("_");
    String? blockedBy;
    bool? isRemoved;
    String result;

    DocumentSnapshot chatroomSnapshot =
        await _firestore.collection('chat_room').doc(chatRoomId).get();

    if (chatroomSnapshot.exists) {
      // store data
      final data = chatroomSnapshot.data() as Map<String, dynamic>?;
      // retrieve attribute
      blockedBy = data?['blockedby'] as String? ?? "";
      isRemoved = data?['removed'] as bool? ?? false;
    }
    if (isRemoved!) {
      result = "Removed";
      return result;
    }
    if (blockedBy != "") {
      result = "Blocked";
      return result;
    } else {
      return "";
    }
  }

  // get unread message count
  Stream<int> getUnreadMessageCount(String otherUserID) {
    String currentUserID = _auth.currentUser!.uid;
    List<String> ids = [otherUserID, currentUserID];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data()?['user1'] == currentUserID) {
          return snapshot.data()?['unreaduser1'];
        } else {
          return snapshot.data()?['unreaduser2'];
        }
      }
      return 0;
    });
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
    // create chatroom and assign unique id
    List<String> ids = [currentUser!.uid, userID];
    // ensure both users have same chat room no matter who logs in
    ids.sort();
    String chatRoomId = ids.join("_");

    // push the user to blocked collection
    await _firestore
        .collection("users")
        .doc(currentUser.uid)
        .collection("blocked_users")
        .doc(userID)
        .set({});

    // update chat room blocked status
    await _firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .update({'blockedby': currentUser.uid});

    notifyListeners();
  }

  // unblock user
  Future<void> unblockUser(String blockedUserID) async {
    final currentUser = _auth.currentUser;
    // create chatroom and assign unique id
    List<String> ids = [currentUser!.uid, blockedUserID];
    // ensure both users have same chat room no matter who logs in
    ids.sort();
    String chatRoomId = ids.join("_");

    // remove blocked user
    await _firestore
        .collection("users")
        .doc(currentUser.uid)
        .collection("blocked_users")
        .doc(blockedUserID)
        .delete();

    // update chat room blocked status after checking blockedby
    DocumentSnapshot chatroomSnapshot =
        await _firestore.collection('chat_room').doc(chatRoomId).get();
    final data = chatroomSnapshot.data() as Map<String, dynamic>?;
    if (data?['blockedby'] == currentUser.uid) {
      await _firestore
          .collection('chat_room')
          .doc(chatRoomId)
          .update({'blockedby': ""});
    }
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

  // delte all messages from a chatroom
  Future<void> deleteAllMessages(String chatRoomId) async {
    final messagesCollection = _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages");

    // Get all documents in the 'messages' collection
    final messagesSnapshot = await messagesCollection.get();

    // Delete each document
    for (var doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  // delete chat room if the other user is deleted
  Future<void> deleteChatRoom(String userID) async {
    // create chatroom id
    List<String> ids = [userID, _auth.currentUser!.uid];
    ids.sort();
    String chatRoomId = ids.join("_");

    // delete messages from this chatroom
    deleteAllMessages(chatRoomId);

    // delete chat room
    await _firestore.collection("chat_room").doc(chatRoomId).delete();
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
