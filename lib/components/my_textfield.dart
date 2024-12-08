import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  final String hintText;
  final bool obsecureText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  const MyTextfield(
      {super.key,
      required this.hintText,
      required this.obsecureText,
      required this.controller,
      this.focusNode
      });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        obscureText: widget.obsecureText,
        cursorColor: Theme.of(context).colorScheme.primary,
        style: TextStyle(
          fontFamily: "Hoves",
          fontSize: 16,
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withOpacity(0.2))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withOpacity(0.5))),
            fillColor: Theme.of(context).colorScheme.tertiaryContainer,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontFamily: "Hoves",
              fontSize: 16,
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.4),
            )),
      ),
    );
  }
}
