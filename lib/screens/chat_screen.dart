import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/components/chat_bubble.dart';
import 'package:textual_chat_app/components/my_textfield.dart';
import 'package:textual_chat_app/services/auth/auth_service.dart';
import 'package:textual_chat_app/services/chat/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  ChatScreen(
      {super.key, required this.receiverEmail, required this.receiverID});

  // get auth and chat services
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  // get controller for messages
  final TextEditingController _messageController = TextEditingController();

  

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // init focusnode
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // scroll when keyboard opens
    myFocusNode.addListener(() {
      // wait a while then scroll down
      Future.delayed(
        const Duration(milliseconds: 500), 
        () => scrollDown(),
        );
    });
    // scroll when screen opens
    Future.delayed(
        const Duration(milliseconds: 500), 
        () => scrollDown(),
        );
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    widget._messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    // if there is any text in the textfield
    if (widget._messageController.text.isNotEmpty) {
      // send message
      await widget._chatService.sendMessage(widget.receiverID, widget._messageController.text);

      // clear textfield
      widget._messageController.clear();
      scrollDown();
    }
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        scrolledUnderElevation:0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
        title: Text(
          widget.receiverEmail,
          style: const TextStyle(
            fontFamily: "Hoves",
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // display all the messages
          Expanded(
            child: _buildMessageList(),
          ),

          // send message textfield and icon
          _buildMessageInput(),
        ],
      ),
    );
  }

  // extracted methods

  Widget _buildMessageList() {
    String senderId = widget._authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: widget._chatService.getMessages(senderId, widget.receiverID),
        builder: (context, snapshot) {
          // errors
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error",
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: "Hoves",
                  fontSize: 16,
                ),
              ),
            );
          }

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer,
              ),
            );
          }

          // return listview
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageTile(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageTile(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // check who is the current user
    bool isCurrentUser = data["senderId"] == widget._authService.getCurrentUser()!.uid;

    // align message to the right if sender is current user otherwise left
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: 
        ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.only(bottom: 25, top: 15),
      child: Row(
        children: [
          Expanded(
              child: MyTextfield(
                  hintText: "Type a message",
                  obsecureText: false,
                  controller: widget._messageController,
                  focusNode: myFocusNode,)
          ),
          Container(
            margin: const EdgeInsets.only(right: 25),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(50)
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: SvgPicture.asset(
                AppAssets.sendIcon,
                color: AppAssets.darkBackgroundColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
