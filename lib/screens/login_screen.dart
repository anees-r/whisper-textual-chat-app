import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/components/my_button.dart';
import 'package:textual_chat_app/components/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController(); 

  final void Function()? onTap; 

  void _login() {}

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            SvgPicture.asset(
              AppAssets.chatIcon,
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.5),
              width: 120,
              height: 120,
            ),

            const SizedBox(
              height: 25,
            ),

            // welcome back message
            Text(
              "Welcome back, you've been missed!",
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.5),
                fontFamily: "Hoves",
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // email textfield
            MyTextfield(hintText: "Email", obsecureText: false, controller: widget._emailController,),

            const SizedBox(
              height: 10,
            ),

            // pw textfield
            MyTextfield(hintText: "Password", obsecureText: true, controller: widget._pwController,),

            const SizedBox(
              height: 25,
            ),

            // login button
            MyButton(text: "Login", onTap: widget._login,),

            const SizedBox(
              height: 25,
            ),

            // register button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member? ",
                style: TextStyle(
                  color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.5),
                fontFamily: "Hoves",
                fontSize: 16
                ),
                ),

                GestureDetector(
                  onTap: widget.onTap,
                  child: Text("Register now",
                  style: TextStyle(
                    color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.5),
                  fontFamily: "Hoves",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                )
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
