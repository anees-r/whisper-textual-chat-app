import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/services/auth/auth_service.dart';
import 'package:textual_chat_app/components/my_button.dart';
import 'package:textual_chat_app/components/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final void Function()? onTap;

  // login method
  void _login(BuildContext context) async {
    // get auth service
    final authService = AuthService();

    // log in
    try {
      await authService.loginWithEmailPassword(
          _emailController.text, _pwController.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  "Error",
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Hoves",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  e.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    fontFamily: "Hoves",
                    fontSize: 16,
                  ),
                ),
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
  }

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
                    .secondaryContainer,
                fontFamily: "Hoves",
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // email textfield
            MyTextfield(
              hintText: "Email",
              obsecureText: false,
              controller: widget._emailController,
            ),

            const SizedBox(
              height: 10,
            ),

            // pw textfield
            MyTextfield(
              hintText: "Password",
              obsecureText: true,
              controller: widget._pwController,
            ),

            const SizedBox(
              height: 25,
            ),

            // login button
            MyButton(text: "Login", onTap: () => widget._login(context)),

            const SizedBox(
              height: 25,
            ),

            // register button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withOpacity(0.5),
                      fontFamily: "Hoves",
                      fontSize: 16),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer,
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
