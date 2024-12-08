import 'package:flutter/material.dart';
import 'package:textual_chat_app/app_assets.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 2.5),
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
        ),),
    );
  }
}
