import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/loginController.dart';
import '../../widgets/loginwid.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

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
