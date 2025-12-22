import 'package:flutter/material.dart';
import 'package:prexam/widgets/registerwid.dart';
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RegisterWid.registerStudent(
       
      ),
    );
  }
}
