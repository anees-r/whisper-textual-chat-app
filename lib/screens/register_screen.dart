import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/auth/auth_service.dart';
import 'package:textual_chat_app/components/my_button.dart';
import 'package:textual_chat_app/components/my_textfield.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key, required this.onTap});

  final void Function()? onTap;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  void _register(BuildContext context) async {
    final _authService = AuthService();

    // register if passwords match
    if (_pwController.text == _confirmPwController.text) {
      try {
        await _authService.registerWithEmailPassword(
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
                    color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1), // Outline color
                    width: 2.0, // Outline thickness
                  ),
                ),
                ));
      }
    } else {
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
                  "Passwords dont match!",
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
                    color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1), // Outline color
                    width: 2.0, // Outline thickness
                  ),
                ),
              ));
    }
  }

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
              height: 10,
            ),

            // confirm pw textfield
            MyTextfield(
              hintText: "Confirm Password",
              obsecureText: true,
              controller: widget._confirmPwController,
            ),

            const SizedBox(
              height: 25,
            ),

            // login button
            MyButton(text: "Register", onTap: () => widget._register(context)),

            const SizedBox(
              height: 25,
            ),

            // register button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
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
                    "Login now",
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
