import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:prexam/controllers/reminder_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prexam/screens/notifi_screen.dart'; // Make sure this file contains NotificationInboxScreen
import 'package:prexam/widgets/mainhome/notification_service.dart' as notifService;

class TopHeader extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const TopHeader({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<TopHeader> createState() => _TopHeaderState();
}

class _TopHeaderState extends State<TopHeader> {
  String username = "User";
  String profileImageUrl = '';

  final ReminderController controller = Get.find<ReminderController>();

  @override
  void initState() {
    super.initState();
    loadUserData();

    // Listen for notification triggers
    notifService.NotificationService.onNotificationTriggered = (id) {
      if (mounted) {
        controller.incrementFiredCount();
        debugPrint("🔥 Notification triggered! ID: $id at ${DateTime.now()}");
      }
    };
  }

  Future<void> loadUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (mounted) {
          setState(() {
            username = data?['username'] ?? 'User';
            profileImageUrl = data?['profileImage'] ?? '';
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile / Open drawer
        GestureDetector(
          onTap: () {
            widget.scaffoldKey.currentState?.openDrawer();
            debugPrint("📂 Drawer opened at ${DateTime.now()}");
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            backgroundImage: profileImageUrl.isNotEmpty
                ? NetworkImage(profileImageUrl)
                : null,
            child: profileImageUrl.isEmpty
                ? const Icon(Icons.person, size: 25)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        // Username
        Expanded(
          child: Text(
            "Hello, $username",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Teacher',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Notifications
        Obx(
          () => Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  // ✅ Navigate safely
                  Get.to(() =>  NotificationInboxScreen());
                },
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              if (controller.firedNotifications.value > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${controller.firedNotifications.value}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
