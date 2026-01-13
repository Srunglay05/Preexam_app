import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/controllers/reminder_controller.dart';
import 'package:prexam/screens/home.dart';
import 'package:prexam/admin/options_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:prexam/widgets/mainhome/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prexam/screens/authentication/login.dart';



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

  // runApp(DevicePreview(
  //   enabled: true,
  //   builder: (context) => const MyApp(),
  // ));
   runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/admin', page: () => OptionsScreen()),
        GetPage(name: '/login', page: () => LoginScreen()), // import if needed
      ],
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> checkLogin(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Not logged in → go to login screen
      Get.offAllNamed('/login');
      return;
    }

    // Logged in → fetch role from Firestore
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      Get.offAllNamed('/login');
      return;
    }

    final data = doc.data() as Map<String, dynamic>;
    final role = data['role']?.toString().trim().toLowerCase() ?? 'user';
    print("🔥 SplashScreen UID: ${user.uid}, ROLE: $role");

    if (role == 'admin') {
      Get.offAllNamed('/admin');
    } else {
      Get.offAllNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Delay 3-4 seconds for splash
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 4), () {
        checkLogin(context);
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
