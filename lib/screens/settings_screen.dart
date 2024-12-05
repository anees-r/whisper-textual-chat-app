import 'package:flutter/material.dart';

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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
            onPressed: (){
              // pop settings screen
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.5),
            )),
        title: Text(
          "S E T T I N G S",
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withOpacity(0.5),
            fontFamily: "Hoves",
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
