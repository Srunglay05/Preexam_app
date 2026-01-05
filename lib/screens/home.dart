
import 'package:flutter/material.dart';
import 'package:prexam/screens/mainhome.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study App Onboarding',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color.fromARGB(255, 31, 82, 193),
            ],
            stops: [0.6, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/plogo.png',
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get your',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 55,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Teacher',
                      height: 1.2,
                    ),
                  ),
                  Text(
                    'better Result',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 55,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Teacher',
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'This app helps students study smarter and get better grades.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontFamily: 'Teacher',
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 65),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeMainScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Get start',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Teacher',
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
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
