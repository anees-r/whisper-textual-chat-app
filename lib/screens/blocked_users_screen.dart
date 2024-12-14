import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/components/my_snackbar.dart';
import 'package:textual_chat_app/components/user_tile.dart';
import 'package:textual_chat_app/services/auth/auth_service.dart';
import 'package:textual_chat_app/services/chat/chat_service.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  // calling chat and auth services
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  // show unblock diaglogue
  void _showUnblockBox(BuildContext context, String userID){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Unblock User",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontFamily: "Hoves",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "Are you sure you want to unblock this user?",
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
                      ChatService().unblockUser(userID);
                      mySnackbar(context, "Whisperer Unblocked!", Theme.of(context).colorScheme.primary);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: AppAssets.darkBackgroundColor,
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: const Text("Unblock")),
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
    // get current users id
    String userID = _authService.getCurrentUser()!.uid;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor:
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_rounded)),
          title: const Text(
            "B L O C K E D   U S E R S",
            style: TextStyle(
              fontFamily: "Hoves",
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chatService.getBlockedUserStream(userID),
          builder: (context, snapshot) {
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
                color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                height: 40,
                width: 40,)
              );
            }

            final blockedUser = snapshot.data ?? [];

            // if no blocked users
            if (blockedUser.isEmpty){
              return Center(
                child: Text(
              "No blocked whisperers!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
                fontFamily: "Hoves",
                fontSize: 16,
              ),
            ));
            }

            // listview
            return ListView.builder(
              itemCount: blockedUser.length,
              itemBuilder: (context, index) {
                final user = blockedUser[index];
                return UserTile(text: user["email"], onTap: () => _showUnblockBox(context, user["uid"]),);
              },
            );
          },
        ));
  }
}
