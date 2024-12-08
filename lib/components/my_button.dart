import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  const MyButton({super.key, required this.text, required this.onTap});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(15)
        ),
          child: Center(
            child: Text(widget.text,
            style: TextStyle(
              fontFamily: "Hoves",
              fontSize: 20,
              color: Theme.of(context).colorScheme.primaryContainer
            ),),
          ),
        
      ),
    );
  }
}