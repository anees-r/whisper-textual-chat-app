import 'package:flutter/material.dart';
import 'package:textual_chat_app/screens/login_screen.dart';
import 'package:textual_chat_app/screens/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginScreen = true;

  void toggleScreen(){
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginScreen){
      return LoginScreen(onTap: toggleScreen,);
    }
    else{
      return RegisterScreen(onTap: toggleScreen,);
    }
  }
}