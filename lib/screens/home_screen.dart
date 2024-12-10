import 'package:flutter/material.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/components/my_drawer.dart';
import 'package:textual_chat_app/components/user_tile.dart';
import 'package:textual_chat_app/screens/chat_screen.dart';
import 'package:textual_chat_app/services/auth/auth_service.dart';
import 'package:textual_chat_app/services/chat/chat_service.dart';
import 'package:textual_chat_app/services/requests/requests_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  // get auth and chat services
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _requestController = TextEditingController();
  final _requestService = RequestsService();

  // open send request box
  void openSendRequestBox() {
    double screenWidth = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Request Whisperer",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontFamily: "Hoves",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Container(
                width: screenWidth * 0.7,
                child: TextField(
                  cursorColor: Theme.of(context).colorScheme.primary,
                  controller: _requestController,
                  style: TextStyle(
                    fontFamily: "Hoves",
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Whisperer's Email",
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
              actions: [
                // cancel button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    shadowColor: Colors.black.withOpacity(0.0), // Shadow color
                  ),
                  child: const Text("Cancel"),
                ),

                // add button
                ElevatedButton(
                  onPressed: () async {
                    // if empty show error
                    if (_requestController.text.isEmpty) {
                      // Show error SnackBar if input is empty

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Email can not be empty!",
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
                      return;
                    } else {
                      // send friend request
                      String returnedText = await _requestService.sendRequest(_requestController.text) as String;

                      // clear the text field
                      _requestController.clear();

                      // close request box
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            returnedText,
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
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor:
                        AppAssets.darkBackgroundColor, // Background color
                    shadowColor: Colors.black.withOpacity(0.0), // Shadow color
                  ),
                  child: const Text("Request"),
                ),
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
        title: Text(
          // adding ! at the end assigns a String? value to String
          widget._authService.getCurrentUser()!.email!,
          style: const TextStyle(
            fontFamily: "Hoves",
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openSendRequestBox();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Custom border radius
        ),
        child: Icon(
          Icons.add,
          color: AppAssets.darkBackgroundColor,
        ),
      ),
    );
  }

  // extracted methods
  Widget _buildUserList() {
    return StreamBuilder(
        stream: widget._chatService.getUserStreamExcludingBlockedAndDeleted(),
        builder: (context, snapshot) {
          // error
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

          final users = snapshot.data ?? [];

          // if no users
          if (users.isEmpty) {
            return Center(
              child: Text(
                "No Whisperers!",
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

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            );
          }

          // listview
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListTile(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListTile(
      Map<String, dynamic> userData, BuildContext context) {
    // displaying all user except current user
    if (userData["email"] != widget._authService.getCurrentUser()!.email) {
      return UserTile(
          text: userData["email"],
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    receiverEmail: userData["email"],
                    receiverID: userData["uid"],
                  ),
                ));
          });
    } else {
      return Container();
    }
  }
}
