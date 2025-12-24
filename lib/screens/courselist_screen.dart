import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/screens/science_screen.dart';

class CourselistScreen extends StatelessWidget {
  const CourselistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30, // 👈 CUSTOM BACK ICON SIZE
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Course List',
          style: TextStyle(
            fontFamily: 'Teacher',
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// ===== TOP CARD =====
            GestureDetector(
              onTap: () {},
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Check For \n New Courses',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Teacher',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -15,
                    bottom: -15,
                    child: Image.asset(
                      'assets/images/stlogy.png',
                      width: 210,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const SizedBox(height: 20),

            /// ===== PRE-DOCTOR =====
            _courseCard(
              color: const Color(0xFF1E88E5),
              title: 'Pre-Doctor \n Examination',
              image: 'assets/images/Dr.png',
              iconSize: 180, // 👈 CUSTOM ICON SIZE
              onTap: () => Get.to(() => const ScienceScreen()),
            ),

            /// ===== PRE-IFL =====
            _courseCard(
              color: Colors.green.shade200,
              title: 'Pre-IFL \n Examination',
              image: 'assets/images/IFL.png',
              iconSize: 140,
              onTap: () {},
            ),

            /// ===== PRE-RUPP =====
            _courseCard(
              color: Colors.orange,
              title: 'Pre-RUPP \n Examination',
              image: 'assets/images/RUPP_logo.png',
              iconSize: 125,
              onTap: () {},
            ),

            /// ===== CHEMISTRY =====
            /*_courseCard(
              color: Colors.red,
              title: 'Chemistry',
              image: 'assets/images/chemistryicon.png',
              iconSize: 130,
              onTap: () {},
            ),*/

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  /// ===== REUSABLE COURSE CARD =====
  Widget _courseCard({
    required Color color,
    required String title,
    required String image,
    required VoidCallback onTap,
    double iconSize = 170, // 👈 DEFAULT SIZE
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Teacher',
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 7.5,
              bottom: 5,
              child: Image.asset(
                image,
                width: iconSize, // 👈 ICON SIZE USED HERE
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
