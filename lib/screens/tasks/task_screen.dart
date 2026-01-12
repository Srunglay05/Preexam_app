import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/screens/tasks/social/social_screen.dart';
import 'package:prexam/screens/tasks/science/science_screen.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Task',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Teacher',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20),

            /// 🔵 SCIENCE CARD
            GestureDetector(
              onTap: () => Get.to(() => ScienceScreen()),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF1E88E5),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(right: 60),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Science',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            //fontWeight: FontWeight.bold,
                            fontFamily: 'Teacher',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -25,
                    bottom: -15,
                    child: Image.asset(
                      'assets/images/scienceicon.png',
                      width: 190,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            Divider(thickness: 1, color: Colors.black),
            SizedBox(height: 30),

            /// 🔴 SOCIAL CARD
            GestureDetector(
              onTap: () => Get.to(() => SocialScreen()),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 244, 143, 143),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Social',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            //fontWeight: FontWeight.bold,
                            fontFamily: 'Teacher',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -25,
                    bottom: -15,
                    child: Image.asset(
                      'assets/images/socialicon.png',
                      width: 190,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
