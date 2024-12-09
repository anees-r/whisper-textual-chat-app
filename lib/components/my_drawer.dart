import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/screens/requests_screen.dart';
import 'package:textual_chat_app/services/auth/auth_service.dart';
import 'package:textual_chat_app/screens/settings_screen.dart';

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
      final _authService = AuthService();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: AppAssets.lightBackgroundColor,
                        shadowColor: Colors.black.withOpacity(0.5),
                      ),
                      child: const Text("Logout")),
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
                  onTap: () {
                    // navigate to settings screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RequestsScreen()));
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
              title: const Text(
                "L O G O U T",
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: "Hoves",
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              leading: SvgPicture.asset(
                AppAssets.logoutIcon,
                color: Colors.red,
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
}
