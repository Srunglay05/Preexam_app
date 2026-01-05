import 'dart:async';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get/get.dart';
import 'package:prexam/controllers/reminder_controller.dart';
import 'package:prexam/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:prexam/widgets/mainhome/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  // needed for async Firebase init
    tz.initializeTimeZones();
      await NotificationService.init();

     NotificationService.onNotificationTriggered = (id) {
    print("🔔 Notification fired! ID: $id");
    // Update your controller badge count
    final controller = Get.put(ReminderController());
    controller.incrementFiredCount();
  };

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(ReminderController());
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>const MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
   Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true, 
      locale: DevicePreview.locale(context), 
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 4), () {
        Get.off(() => HomeScreen()); 
      });
    });

    return Scaffold(
      body: SplashContent(),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
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

