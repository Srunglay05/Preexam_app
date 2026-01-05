import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prexam/controllers/reminder_controller.dart';
import 'package:prexam/screens/reminder_list_page.dart';
import 'package:prexam/widgets/mainhome/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  File? profileImage;
  Uint8List? profileImageBytes;
  String username = "User";

  final ReminderController controller = Get.find<ReminderController>();

  @override
  void initState() {
    super.initState();
    loadProfileImage();
    loadUsername();

    NotificationService.onNotificationTriggered = (id) {
      controller.incrementFiredCount();
    };
  }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    if (kIsWeb) {
      final base64Str = prefs.getString('profile_image_web');
      if (base64Str != null) {
        setState(() {
          profileImageBytes = base64Decode(base64Str);
        });
      }
    } else {
      final path = prefs.getString('profile_image');
      if (path != null && File(path).existsSync()) {
        setState(() {
          profileImage = File(path);
        });
      }
    }
  }

  Future<void> loadUsername() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        setState(() {
          username = doc.data()?['username'] ?? 'User';
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ✅ OPEN DRAWER HERE
        GestureDetector(
          onTap: () {
            widget.scaffoldKey.currentState?.openDrawer();
          },
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: kIsWeb
                ? (profileImageBytes != null
                    ? MemoryImage(profileImageBytes!)
                    : null)
                : (profileImage != null
                    ? FileImage(profileImage!)
                    : null) as ImageProvider?,
            child: (profileImage == null && profileImageBytes == null)
                ? const Icon(Icons.person, size: 30)
                : null,
          ),
        ),

        const SizedBox(width: 10),

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

        Obx(
          () => Stack(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => ReminderListPage());
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
