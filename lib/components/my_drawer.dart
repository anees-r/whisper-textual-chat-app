import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/components/my_snackbar.dart';
import 'package:textual_chat_app/screens/requests_screen.dart';
import 'package:textual_chat_app/services/auth/auth_service.dart';
import 'package:textual_chat_app/screens/settings_screen.dart';
import 'package:textual_chat_app/services/requests/requests_service.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // log out method
  void _logout() {
    // getting auth service
    final authService = AuthService();
    authService.logOut();
  }

  void _showLogoutBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontFamily: "Hoves",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "Are you sure you want to logout?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontFamily: "Hoves",
                  fontSize: 16,
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
                      foregroundColor: Theme.of(context)
                          .colorScheme
                          .secondaryContainer, // Background color
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: const Text("Cancel")),

                // log out button
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      _logout();
                      mySnackbar(context, "Logout Successful!",
                          Theme.of(context).colorScheme.primary);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: AppAssets.darkBackgroundColor,
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: const Text("Logout")),
              ],
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // logo
          Column(
            children: [
              DrawerHeader(
                child: SvgPicture.asset(
                  AppAssets.chatIcon,
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.5),
                  width: 60,
                  height: 60,
                ),
              ),

              // home
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text(
                    "H O M E",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      fontFamily: "Hoves",
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: SvgPicture.asset(
                    AppAssets.homeIcon,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              // requests
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text(
                    "R E Q U E S T S",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      fontFamily: "Hoves",
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: SvgPicture.asset(
                    AppAssets.requestsIcon,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  trailing: buildRequestsCount(),
                  onTap: () {
                    // navigate to settings screen
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RequestsScreen()))
                        .then((_) => setState(() {}));
                  },
                ),
              ),

              // settings
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text(
                    "S E T T I N G S",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      fontFamily: "Hoves",
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: SvgPicture.asset(
                    AppAssets.settingsIcon,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onTap: () {
                    // navigate to settings screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()));
                  },
                ),
              ),
            ],
          ),

          // logout
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              title: Text(
                "L O G O U T",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: "Hoves",
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              leading: SvgPicture.asset(
                AppAssets.logoutIcon,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () {
                _showLogoutBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  // get requests count
  Widget buildRequestsCount() {
    return StreamBuilder<int>(
        stream: RequestsService().getRequestsCount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(width: 0, height: 0,);
          }

          final unreadCount = snapshot.data ?? 0;

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
        });
  }
}
