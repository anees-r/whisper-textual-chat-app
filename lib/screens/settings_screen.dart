import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/components/my_snackbar.dart';
import 'package:textual_chat_app/screens/blocked_users_screen.dart';
import 'package:textual_chat_app/services/auth/auth_service.dart';
import 'package:textual_chat_app/themes/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showDeleteBox(BuildContext context) {
    final _authService = AuthService();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Delete Account!",
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: "Hoves",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "This is a permanent action! All of your data will be deleted.",
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
                      _authService.deleteAccount();
                      mySnackbar(context, "Account Deleted!", Colors.red);
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
        title: const Text(
          "S E T T I N G S",
          style: TextStyle(
            fontFamily: "Hoves",
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(
                    fontFamily: "Hoves",
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),

                // switch
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                  activeColor: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BlockedUsersScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Blocked Users",
                    style: TextStyle(
                      fontFamily: "Hoves",
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ),

                  // arrow icon
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ],
              ),
            ),
          ),

          // delete account
          GestureDetector(
            onTap: () {
              _showDeleteBox(context);
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(15)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Delete Account",
                    style: TextStyle(
                      fontFamily: "Hoves",
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
