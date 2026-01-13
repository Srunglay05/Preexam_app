import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/controllers/loginController.dart';
import 'package:prexam/widgets/loginwid.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ✅ REGISTER CONTROLLER
    Get.put(LoginController());

    return Scaffold(
      body: LoginWid.inputStudent(
        controller1: emailController,
        controller2: passwordController,
        context: context,
      ),
    );
  }
}
