import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/components/my_button.dart';
import 'package:textual_chat_app/components/my_textfield.dart';

class RegisterScreen extends StatefulWidget {
 RegisterScreen({super.key, required this.onTap});

  final void Function()? onTap;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();  

  void _register() {}

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
              "Let's create an account for you!",
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
              height: 10,
            ),

            // confirm pw textfield
            MyTextfield(hintText: "Confirm Password", obsecureText: true, controller: widget._confirmPwController,),

            const SizedBox(
              height: 25,
            ),

            // login button
            MyButton(text: "Register", onTap: widget._register,),

            const SizedBox(
              height: 25,
            ),

            // register button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ",
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
                  child: Text("Login now",
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