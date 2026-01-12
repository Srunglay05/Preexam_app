import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:prexam/controllers/loginController.dart';

class LoginWid {
  static Widget inputStudent({
    required TextEditingController controller1,
    required TextEditingController controller2,
    required BuildContext context,
  }) {
    final LoginController controller = Get.find<LoginController>();

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

            /// EMAIL
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: controller1,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter Your Email',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// PASSWORD
            Obx(() => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller2,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Password',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 18),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
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
                  ),
                )),

            const SizedBox(height: 25),

            /// 🔽 ROLE DROPDOWN (UI ONLY)
            Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedRole.value,
                      isExpanded: true,
                      style: const TextStyle(
                        fontFamily: 'Teacher',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'User',
                          child: Text('User',
                              style: TextStyle(fontFamily: 'Teacher')),
                        ),
                        DropdownMenuItem(
                          value: 'Admin',
                          child: Text('Admin',
                              style: TextStyle(fontFamily: 'Teacher')),
                        ),
                      ],
                      onChanged: (value) {
                        controller.selectedRole.value = value!;
                      },
                    ),
                  ),
                )),

            const SizedBox(height: 40),

            /// LOGIN BUTTON
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(() => SizedBox(
                    width: 190,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.username.text = controller1.text;
                              controller.password.text = controller2.text;
                              controller.login();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Log in",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Teacher',
                              ),
                            ),
                    ),
                  )),
            ),

            const SizedBox(height: 20),

            /// FORGOT PASSWORD
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: controller.forgotPassword,
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// DIVIDER
            Row(
              children: const [
                Expanded(child: Divider(color: Colors.black)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "or",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Teacher',
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.black)),
              ],
            ),

            const SizedBox(height: 40),

            /// GOOGLE LOGIN
            Obx(() => Container(
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
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.loginWithGoogle,
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
                          Image.asset(
                            "assets/images/google.png",
                            width: 24,
                            height: 24,
                          ),
                          const Spacer(),
                          const Text(
                            "Sign In with Google",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontFamily: 'Teacher',
                            ),
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                )),

            const SizedBox(height: 25),

            /// APPLE BUTTON (UI ONLY)
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
                    debugPrint("Apple Sign-In pressed");
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
                    children: const [
                      FaIcon(FontAwesomeIcons.apple,
                          size: 30, color: Colors.black),
                      Spacer(),
                      Text(
                        "Sign In With AppleID",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontFamily: 'Teacher',
                        ),
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
