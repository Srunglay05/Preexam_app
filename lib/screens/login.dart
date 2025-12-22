import 'package:flutter/material.dart';
import '../widgets/loginwid.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoginWid.inputStudent(
        controller1: username,
        controller2: password,
        context: context,
      ),
    );
  }
}
