import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/controllers/reminder_controller.dart';
import 'package:prexam/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:prexam/widgets/mainhome/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize timezone & notifications
  tz.initializeTimeZones();
  await NotificationService.init();

  // Initialize controller
  final reminderController = Get.put(ReminderController());

  // Notification callback
  NotificationService.onNotificationTriggered = (id) {
    print("🔔 Notification fired! ID: $id");
    reminderController.incrementFiredCount();
  };

  // Load reminders
  await reminderController.loadReminders();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 4), () {
        Get.off(() => HomeScreen());
      });
    });

    return const Scaffold(
      body: SplashContent(),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A00E0),
            Color(0xFF00C6FF),
          ],
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text(
            "Prexam",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 100,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontFamily: 'Teacher',
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
