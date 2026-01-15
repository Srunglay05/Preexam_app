import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/controllers/reminder_controller.dart';
import 'package:prexam/screens/home.dart';
import 'package:prexam/admin/options_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:prexam/widgets/mainhome/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prexam/screens/authentication/login.dart';
import '../models/reminder.dart';
import 'package:prexam/screens/notifi_screen.dart';

// Firebase App Check
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Activate Firebase App Check in debug mode (for development)
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  // Initialize timezone & notifications
  tz.initializeTimeZones();
  await NotificationService.init();

  // Request notification permission
  await requestNotificationPermission();
  await NotificationService.requestPermission();

  // Initialize ReminderController
  final reminderController = Get.put(ReminderController());

  // 🔔 Listen to notification fired events
  NotificationService.onNotificationTriggered = (id) async {
    debugPrint("🔥 Notification fired! ID: $id");

    final controller = Get.find<ReminderController>();

    // Find reminder by ID
    Reminder? reminder;
    try {
      reminder = controller.reminders.firstWhere((r) => r.id == id);
    } catch (_) {
      reminder = null;
    }

    if (reminder == null) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    // ✅ Store fired notification in Firestore
    await userRef.collection('notifications').doc(id.toString()).set({
      'title': reminder.title,
      'message': reminder.description,
      'subject': 'Reminder',
      'time': DateTime.now(),
      'read': false,
    });

    controller.incrementFiredCount();
    debugPrint("✅ Notification stored in Firestore");
  };

  runApp(const MyApp());
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.request().isGranted) {
    debugPrint("✅ Notification permission granted");
  } else {
    debugPrint("❌ Notification permission denied");
  }
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
        GetPage(name: '/login', page: () => LoginScreen()),

      ],
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> checkLogin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.offAllNamed('/login');
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      Get.offAllNamed('/login');
      return;
    }

    final data = doc.data() as Map<String, dynamic>;
    final role = data['role']?.toString().trim().toLowerCase() ?? 'user';
    debugPrint("🔥 SplashScreen UID: ${user.uid}, ROLE: $role");

    if (role == 'admin') {
      Get.offAllNamed('/admin');
    } else {
      Get.offAllNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Delay 3 seconds for splash
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        checkLogin();
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
