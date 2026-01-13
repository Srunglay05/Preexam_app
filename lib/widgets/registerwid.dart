import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prexam/controllers/RegisterController.dart';
import 'package:flutter/gestures.dart';
import 'package:prexam/screens/authentication/login.dart';

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

            /// TITLE
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

            /// USERNAME
            TextField(
              controller: controller.usernameController,
              decoration: _inputDecoration('Enter Your Username'),
            ),

            const SizedBox(height: 25),

            /// EMAIL
            TextField(
              controller: controller.emailController,
              decoration: _inputDecoration('Enter Your Email'),
            ),

            const SizedBox(height: 25),

            /// ROLE DROPDOWN
            // Obx(() => Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 15),
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(20),
            //         border: Border.all(color: Colors.grey),
            //       ),
            //       child: DropdownButtonHideUnderline(
            //         child: DropdownButton<String>(
            //           value: controller.selectedRole.value,
            //           isExpanded: true,
            //           icon: const Icon(Icons.arrow_drop_down),
            //           style: const TextStyle(
            //             fontFamily: 'Teacher',
            //             fontSize: 16,
            //             color: Colors.black,
            //           ),
            //           items: const [
            //             DropdownMenuItem(
            //               value: 'User',
            //               child: Text('User', style: TextStyle(fontFamily: 'Teacher')),
            //             ),
            //             DropdownMenuItem(
            //               value: 'Admin',
            //               child: Text('Admin', style: TextStyle(fontFamily: 'Teacher')),
            //             ),
            //           ],
            //           onChanged: (value) {
            //             controller.selectedRole.value = value!;
            //           },
            //         ),
            //       ),
            //     )),

            const SizedBox(height: 25),

            /// PASSWORD
            Obx(() => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  decoration: _inputDecoration(
                    'Enter Your Password',
                    suffix: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        controller.isPasswordHidden.value =
                            !controller.isPasswordHidden.value;
                      },
                    ),
                  ),
                )),

            const SizedBox(height: 40),

            /// REGISTER BUTTON
            Obx(() => SizedBox(
                  width: 190,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Register',
                            style: TextStyle(
                              fontFamily: 'Teacher',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )),

            const SizedBox(height: 20),

            /// LOGIN LINK
            Align(
              alignment: Alignment.bottomRight,
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Teacher',
                      ),
                    ),
                    TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Teacher',
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.offAll(() => LoginScreen()),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// DIVIDER
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('or',
                      style: TextStyle(fontSize: 20, fontFamily: 'Teacher')),
                ),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 30),

            /// GOOGLE BUTTON
            _socialButton(
              child: Row(
                children: [
                  Image.asset('assets/images/google.png', width: 24),
                  const Spacer(),
                  const Text(
                    'Register with Google',
                    style: TextStyle(fontFamily: 'Teacher', fontSize: 17),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              onPressed: controller.registerWithGoogle,
            ),

            const SizedBox(height: 25),

            /// APPLE BUTTON
            _socialButton(
              child: Row(
                children: const [
                  FaIcon(FontAwesomeIcons.apple, size: 30),
                  Spacer(),
                  Text(
                    'Register with AppleID',
                    style: TextStyle(fontFamily: 'Teacher', fontSize: 17),
                  ),
                  Spacer(flex: 2),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  /// INPUT DECORATION (REUSED)
  static InputDecoration _inputDecoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }

  /// SOCIAL BUTTON STYLE
  static Widget _socialButton({
    required Widget child,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: SizedBox(
        height: 55,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
          ),
          child: child,
        ),
      ),
    );
  }
}
