import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textual_chat_app/themes/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        scrolledUnderElevation:0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
        title: const Text(
          "S E T T I N G S",
          style: TextStyle(
            fontFamily: "Hoves",
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(15)
        ),
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
              value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode, 
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              activeColor: Theme.of(context).colorScheme.primary,)
          ],
        ),
      ),
    );
  }
}
