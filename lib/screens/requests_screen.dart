import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:textual_chat_app/components/request_tile.dart';
import 'package:textual_chat_app/services/requests/requests_service.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    // init request service
    final _requestService = RequestsService();
    // init auth instance
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        scrolledUnderElevation:0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
        title: const Text(
          // adding ! at the end assigns a String? value to String
          "W H I S P E R   R E Q U E S T S",
          style: TextStyle(
            fontFamily: "Hoves",
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _requestService.getRequests(_auth.currentUser!.uid),
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
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
              );
            }

            final requestUser = snapshot.data ?? [];

            // if no blocked users
            if (requestUser.isEmpty){
              return Center(
                child: Text(
              "No whisper requests!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
                fontFamily: "Hoves",
                fontSize: 16,
              ),
            ));
            }

            // listview
            return ListView.builder(
              itemCount: requestUser.length,
              itemBuilder: (context, index) {
                final user = requestUser[index];
                return RequestTile(text: user["email"],);
              },
            );
          },
        )
    );
  }
}