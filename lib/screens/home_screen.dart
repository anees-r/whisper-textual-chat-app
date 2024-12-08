import 'package:flutter/material.dart';
import 'package:textual_chat_app/components/my_drawer.dart';
import 'package:textual_chat_app/components/user_tile.dart';
import 'package:textual_chat_app/screens/chat_screen.dart';
import 'package:textual_chat_app/services/auth/auth_service.dart';
import 'package:textual_chat_app/services/chat/chat_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  // get auth and chat services
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        scrolledUnderElevation:0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
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
    );
  }

  // extracted methods
  Widget _buildUserList() {
    return StreamBuilder(
        stream: widget._chatService.getUserStreamExcludingBlocked(),
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

          // if no users
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No Whisperers!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
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

          // listview
          return ListView(
            children: snapshot.data!
                .map<Widget>((userData) => _buildUserListTile(userData,context))
                .toList(),
          );
        });
  }

  Widget _buildUserListTile(
      Map<String, dynamic> userData, BuildContext context) {
    // displaying all user except current user
    if(userData["email"] != widget._authService.getCurrentUser()!.email){
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
      }
      );
    }else{
      return Container();
    }
  }
}
