import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/services/chat/chat_service.dart';
import 'package:textual_chat_app/services/requests/requests_service.dart';

class UserTile extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({super.key, required this.text, required this.onTap});

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    final bool _isDeleted = widget.text == "Deleted Account";
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // icon
                SvgPicture.asset(
                  AppAssets.userIcon,
                  color: _isDeleted
                      ? Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withOpacity(0.5)
                      : Theme.of(context).colorScheme.secondaryContainer,
                ),

                const SizedBox(
                  width: 20,
                ),
                // username
                Text(
                  widget.text,
                  style: TextStyle(
                    color: _isDeleted
                        ? Theme.of(context)
                            .colorScheme
                            .secondaryContainer
                            .withOpacity(0.5)
                        : Theme.of(context).colorScheme.secondaryContainer,
                    fontFamily: "Hoves",
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            buildUnreadCounter(),
          ],
        ),
      ),
    );
  }

  Widget buildUnreadCounter() {
    return FutureBuilder<String>(
      future: RequestsService().getUidByEmail(widget.text),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(height: 0, width: 0,);
        }

        String otherUserID = snapshot.data as String;

        return StreamBuilder<int>(
          stream: ChatService().getUnreadMessageCount(otherUserID),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(height: 0, width: 0,);
            }

            final unreadCount = streamSnapshot.data ?? 0;

            if (unreadCount > 0) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount.toString(),
                  style: TextStyle(
                    color: AppAssets.darkBackgroundColor,
                    fontSize: 16,
                    fontFamily: "Hoves",
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
