import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prexam/controllers/RegisterController.dart';
import 'package:flutter/gestures.dart';
import 'package:prexam/screens/login.dart';

class RegisterWid {
  static Widget registerStudent() {
    final controller = Get.put(RegisterController());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 75),
            const Text(
              'Welcome',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w700,
                fontFamily: 'Teacher',
                letterSpacing: 1,
                color: Colors.black,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(255, 129, 129, 129),
                    offset: Offset(5, 5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Username
            TextField(
              controller: controller.usernameController,
              decoration: InputDecoration(
                hintText: 'Enter Your Username',
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 25),

            // Email
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                hintText: 'Enter Your Email',
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 25),
            // Password
            Obx(() => TextField(
                controller: controller.passwordController,
                obscureText: controller.isPasswordHidden.value,
                decoration: InputDecoration(
                  hintText: 'Enter Your Password',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      controller.isPasswordHidden.value = !controller.isPasswordHidden.value;
                    },
                  ),
                ),
              )),
            const SizedBox(height: 40),

            // Register Button
            Obx(() {
              return SizedBox(
                width: 190,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          print("Debug: Register button pressed");
                          controller.register();
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Teacher',
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: "Login",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Login tapped");
                          Get.offAll(() => LoginScreen());
                        },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            Row(
              children: const [
                Expanded(child: Divider(color: Colors.black)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "or",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                Expanded(child: Divider(color: Colors.black)),
              ],
            ),
            const SizedBox(height: 40),

            // Google Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                   onPressed: () {
                      RegisterController().registerWithGoogle();
                    },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/google.png", width: 24, height: 24),
                      const Spacer(),
                      const Text(
                        "Register with Google",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Apple Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () => print("Apple Sign-In pressed"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Row(
                    children: const [
                      FaIcon(FontAwesomeIcons.apple, size: 30, color: Colors.black),
                      Spacer(),
                      Text(
                        "Register With AppleID",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
