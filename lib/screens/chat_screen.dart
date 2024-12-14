import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/components/chat_bubble.dart';
import 'package:textual_chat_app/components/my_snackbar.dart';
import 'package:textual_chat_app/services/auth/auth_service.dart';
import 'package:textual_chat_app/services/chat/chat_service.dart';
import 'package:textual_chat_app/services/requests/requests_service.dart';

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
    widget._chatService.markRead(widget._authService.getCurrentUser()!.uid, widget.receiverID);
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    widget._messageController.dispose();
    widget._chatService.markRead(widget._authService.getCurrentUser()!.uid, widget.receiverID);
    super.dispose();
  }

  void sendMessage() async {
    // if there is any text in the textfield
    if (widget._messageController.text.isNotEmpty) {
      // send message
      await widget._chatService
          .sendMessage(widget.receiverID, widget._messageController.text);

      // clear textfield
      widget._messageController.clear();
      scrollDown();
    }
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  // show delete button
  Widget _showDeleteButton(bool unfriend, deleted) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      child: IconButton(
          onPressed: () {
            _showDeleteBox(context, unfriend, deleted);
          },
          icon: SvgPicture.asset(
            AppAssets.deleteIcon,
            color: Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withOpacity(0.5),
          )),
    );
  }

  void _showDeleteBox(BuildContext context, bool unfriend, deleted) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Delete Whispers!",
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: "Hoves",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "This is a permanent action! All of your whispers will be deleted.",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontFamily: "Hoves",
                  fontSize: 16,
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      foregroundColor: Theme.of(context)
                          .colorScheme
                          .secondaryContainer, // Background color
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      if (unfriend || deleted) {
                        if (deleted) {
                          ChatService().deleteUser(widget.receiverID);
                        }
                        ChatService().deleteChatRoom(widget.receiverID);
                      }
                      mySnackbar(context, "Whispers Deleted!",
                          Theme.of(context).colorScheme.primary);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: AppAssets.lightBackgroundColor,
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: const Text("Delete")),
              ],
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ));
  }

  // show options
  void showOptions(BuildContext context, String userID) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // Unfriend button
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _showRemoveFriend(context, userID);
                },
                leading: SvgPicture.asset(
                  AppAssets.removeIcon,
                  height: 18,
                  width: 18,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                title: Text(
                  "Remove Whisperer",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    fontFamily: "Hoves",
                    fontSize: 16,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),

              // block button
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, userID);
                },
                leading: SvgPicture.asset(
                  AppAssets.blockIcon,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                title: Text(
                  "Block Whisperer",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    fontFamily: "Hoves",
                    fontSize: 16,
                  ),
                ),
              ),

              // cancel button
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading: SvgPicture.asset(
                  AppAssets.cancelIcon,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  height: 21,
                  width: 21,
                ),
                title: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    fontFamily: "Hoves",
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // remove friend dialogue
  void _showRemoveFriend(BuildContext context, String userID) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Remove Whisperer",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontFamily: "Hoves",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "Are you sure you want to remove this whisperer?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontFamily: "Hoves",
                  fontSize: 16,
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      foregroundColor: Theme.of(context)
                          .colorScheme
                          .secondaryContainer, // Background color
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      RequestsService().removeFriend(userID);
                      mySnackbar(context, "Whisperer Removed!",
                          Theme.of(context).colorScheme.primary);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: AppAssets.darkBackgroundColor,
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: const Text("Remove")),
              ],
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ));
  }

  // show block dialogue
  void _blockUser(BuildContext context, String userID) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Block Whisperer",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontFamily: "Hoves",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "Are you sure you want to block this user?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontFamily: "Hoves",
                  fontSize: 16,
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      foregroundColor: Theme.of(context)
                          .colorScheme
                          .secondaryContainer, // Background color
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      // pop dialogue
                      Navigator.pop(context);
                      // pop chat screen
                      Navigator.pop(context);
                      ChatService().blockUser(userID);
                      mySnackbar(context, "Whisperer blocked!",
                          Theme.of(context).colorScheme.primary);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: AppAssets.darkBackgroundColor,
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: const Text("Block")),
              ],
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ));
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded)),
        title: GestureDetector(
          onLongPress: () {
            showOptions(context, widget.receiverID);
          },
          child: Text(
            widget.receiverEmail,
            style: const TextStyle(
              fontFamily: "Hoves",
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          _checkRemovedAndDisplayDelete(),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // display all the messages
          Expanded(
            child: _buildMessageList(),
          ),
          // send message textfield and icon
          // _showRemoved(),
          // _buildMessageInput(),
          _checkAndDisplayFooter(),
        ],
      ),
    );
  }

  // extracted methods

  // display delete icon based on email or friend status
  Widget _checkRemovedAndDisplayDelete() {
    bool showDelete = widget.receiverEmail == "Deleted Account";
    return FutureBuilder(
        future: ChatService().checkRemovedAndBlocked(widget.receiverID),
        builder: (context, snapshot) {
          String? conditon = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(height: 0,width: 0,);
          }
          bool unfriended = conditon! == "Removed";
          if (unfriended || showDelete) {
            return _showDeleteButton(unfriended, showDelete);
          } else {
            return Container();
          }
        });
  }

  // display info or the textfield in footer based on friend status
  Widget _checkAndDisplayFooter() {
    bool isDeleted = widget.receiverEmail == "Deleted Account";
    return FutureBuilder(
        future: ChatService().checkRemovedAndBlocked(widget.receiverID),
        builder: (context, snapshot) {
          String? conditon = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: SvgPicture.asset(
                  AppAssets.loadingAnimation,
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.5),
                  height: 38,
                  width: 38,
                ));
          }

          if (conditon == "Removed" || conditon! == "Blocked" || isDeleted) {
            if(isDeleted){
              return _showDeleted();
            }
            if (conditon == "Removed") {
              return _showRemoved();
            } else {
              return _showBlocked();
            }
          } else {
            return _buildMessageInput();
          }
        });
  }

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
                child: SvgPicture.asset(
              AppAssets.loadingAnimation,
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.5),
              height: 40,
              width: 40,
            ));
          }

          // if no messages
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Whispers!",
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.4),
                  fontFamily: "Hoves",
                  fontSize: 16,
                ),
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
    bool isCurrentUser =
        data["senderId"] == widget._authService.getCurrentUser()!.uid;

    // align message to the right if sender is current user otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: ChatBubble(
          message: data["message"],
          isCurrentUser: isCurrentUser,
          messageID: doc.id,
          userID: data["senderId"],
        ));
  }

  Widget _showDeleted() {
    return Container(
      margin: EdgeInsets.all(25),
      child: Center(
          child: Column(
        children: [
          Text(
            "The other whisperer has deleted their account!",
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.5),
              fontFamily: "Hoves",
              fontSize: 14,
            ),
          ),
          Text(
            "Delete chat or ignore.",
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.3),
              fontFamily: "Hoves",
              fontSize: 14,
            ),
          ),
        ],
      )),
    );
  }

  Widget _showRemoved() {
    return Container(
      margin: EdgeInsets.all(25),
      child: Center(
          child: Column(
        children: [
          Text(
            "The other whisperer removed you as friend!",
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.5),
              fontFamily: "Hoves",
              fontSize: 14,
            ),
          ),
          Text(
            "Delete chat or add them again.",
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.3),
              fontFamily: "Hoves",
              fontSize: 14,
            ),
          ),
        ],
      )),
    );
  }

  Widget _showBlocked() {
    return Container(
      margin: const EdgeInsets.all(25),
      child: Center(
          child: Column(
        children: [
          Text(
            "The other whisperer has blocked you!",
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.5),
              fontFamily: "Hoves",
              fontSize: 14,
            ),
          ),
          Text(
            "Block them or ignore.",
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.3),
              fontFamily: "Hoves",
              fontSize: 14,
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.only(bottom: 25, top: 15),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        padding: EdgeInsets.only(top: 4, bottom: 4, left: 20, right: 8),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.2),
                width: 1),
            borderRadius: BorderRadius.circular(500)),
        child: TextFormField(
          focusNode: myFocusNode,
          controller: widget._messageController,
          obscureText: false,
          cursorColor: Theme.of(context).colorScheme.primary,
          style: TextStyle(
            fontFamily: "Hoves",
            fontSize: 16,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15),
              suffixIcon: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(100)),
                child: IconButton(
                  onPressed: sendMessage,
                  icon: SvgPicture.asset(
                    AppAssets.sendIcon,
                    color: AppAssets.darkBackgroundColor,
                  ),
                ),
              ),
              border: InputBorder.none,
              hintText: "Whisper here",
              hintStyle: TextStyle(
                fontFamily: "Hoves",
                fontSize: 16,
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.4),
              )),
        ),
      ),
    );
  }
}
