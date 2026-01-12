import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key}); // ✅ FIXED

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'About Us',
          style: TextStyle(
            fontFamily: 'Teacher',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🖼 TOP IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.asset(
                'assets/images/prexam.png',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // 📄 CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  // TITLE
                  Text(
                    'About Prexam',
                    style: TextStyle(
                      fontFamily: 'Teacher',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12),

                  // DESCRIPTION
                  Text(
                    'Prexam is an educational mobile application created to '
                    'support students in exam preparation and academic '
                    'improvement.\n\n'
                    'The app provides tools for score calculation, '
                    'subject-based evaluation, and performance understanding '
                    'for both Science and Social subjects. Prexam is designed '
                    'with simplicity and accuracy in mind, helping students '
                    'focus on learning without unnecessary complexity.\n\n'
                    'One of our newest features allows users to post, share, '
                    'and explore educational content within the app. This '
                    'feature encourages students to exchange knowledge, share '
                    'useful study tips, and stay updated with new educational '
                    'ideas, creating a supportive learning community.\n\n'
                    'Prexam continues to grow with the goal of making exam '
                    'preparation smarter, more interactive, and more '
                    'accessible for every learner.',
                    style: TextStyle(
                      fontFamily: 'Teacher',
                      fontSize: 18,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
