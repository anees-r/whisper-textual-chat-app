import 'package:flutter/material.dart';
import 'package:textual_chat_app/components/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        // leading: IconButton(
        //     onPressed: (){
        //       // open drawer
        //     },
        //     icon: Icon(
        //       Icons.arrow_back,
        //       color: Theme.of(context)
        //           .colorScheme
        //           .secondaryContainer
        //           .withOpacity(0.5),
        //     )),
        title: Text(
            "Home",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondaryContainer,
              fontFamily: "Hoves",
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
    );
  }
}
