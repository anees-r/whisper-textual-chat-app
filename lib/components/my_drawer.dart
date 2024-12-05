import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/auth/auth_service.dart';
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
    final _authService = AuthService();
    _authService.logOut();
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
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.5),
                  fontFamily: "Hoves",
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              leading: SvgPicture.asset(
                AppAssets.homeIcon,
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.5),
              ),
              onTap: () {
                // pop the drawer
                Navigator.pop(context);
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
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.5),
                  fontFamily: "Hoves",
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              leading: SvgPicture.asset(
                AppAssets.settingsIcon,
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.5),
              ),
              onTap: () {
                // navigate to settings screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
          ),
            ],
          ),

          // logout
          Padding(
            padding: const EdgeInsets.only(left: 25,bottom: 25),
            child: ListTile(
              title: Text(
                "L O G O U T",
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.5),
                  fontFamily: "Hoves",
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              leading: SvgPicture.asset(
                AppAssets.logoutIcon,
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.5),
              ),
              onTap: () {
                 _logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
