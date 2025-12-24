import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:prexam/screens/course_list_screen.dart';//import 'package:prexam/screens/login.dart';
class CourseCard extends StatelessWidget {
  const CourseCard({Key? key}) : super(key: key);

  Future<void> _handleTap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    if (isLoggedIn) {
      // Navigate to the actual course screen
      //Get.to(() => CourseListScreen());
    } else {
      // Not logged in → redirect to login/register
      Get.snackbar("Login required", "Please login or register to access this course");
      Get.to(() => RegisterScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: double.infinity, // responsive width
          constraints: BoxConstraints(maxWidth: 320),
          height: 400,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Image.asset(
                  "assets/images/math.png",
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Mathematic",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Teacher',
                  color: Colors.white,
                ),
              ),
              const Text(
                "Free",
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Teacher',
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
