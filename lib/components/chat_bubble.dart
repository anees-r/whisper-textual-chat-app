import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/services/chat/chat_service.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isCurrentUser;
  final String messageID;
  final String userID;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.messageID,
      required this.userID});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  // show options
  void showOptions(BuildContext context, String messageID, userID) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // report button
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(context, messageID, userID);
                },
                leading: SvgPicture.asset(
                  AppAssets.reportIcon,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                title: Text(
                  "Report",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    fontFamily: "Hoves",
                    fontSize: 16,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
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

  // report
  void _reportMessage(BuildContext context, String messageID, userID) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Report Message",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontFamily: "Hoves",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "Are you sure you want to report this messasge?",
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
                      ChatService().reportUser(messageID, userID);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Message reported!",
                            style: TextStyle(
                              fontFamily: "Hoves",
                              fontSize: 16,
                              color: AppAssets.darkBackgroundColor,
                            ),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,

                          // Margin from the top and sides
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: AppAssets.darkBackgroundColor,
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: const Text("Report")),
              ],
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.1), // Outline color
                  width: 2.0, // Outline thickness
                ),
              ),
            ));
  }

  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!widget.isCurrentUser) {
          // show options
          showOptions(context, widget.messageID, widget.userID);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 2.5),
        decoration: BoxDecoration(
          color: widget.isCurrentUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          widget.message,
          style: TextStyle(
            color: widget.isCurrentUser
                ? AppAssets.darkBackgroundColor
                : Theme.of(context).colorScheme.secondaryContainer,
            fontFamily: "Hoves",
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
