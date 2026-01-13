import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:prexam/screens/about_us.dart';
import 'package:prexam/screens/authentication/register.dart';
import 'package:prexam/admin/options_screen.dart';

import 'wave_clipper.dart';

class DrawerMenus extends StatefulWidget {
  const DrawerMenus({super.key});

  @override
  State<DrawerMenus> createState() => _DrawerMenusState();
}

class _DrawerMenusState extends State<DrawerMenus> {
  String username = 'User';
  String email = '';
  String profileImageUrl = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  /// Fetch user data from Firebase
  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() {
      email = user.email ?? '';
    });

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          username = data['username'] ?? 'User';
          profileImageUrl = data['profileImage'] ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  /// Pick image and upload to Firebase Storage
  Future<void> pickAndUploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    final file = File(pickedFile.path);

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${user.uid}.jpg');

      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profileImage': downloadUrl});

      setState(() {
        profileImageUrl = downloadUrl;
      });
    } catch (e) {
      debugPrint('Image upload error: $e');
    }
  }

  /// Logout user
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) =>  RegisterScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          /// Header
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 240,
              padding: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.lightBlueAccent,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: pickAndUploadImage,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : null,
                      child: profileImageUrl.isEmpty
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Teacher',
                    ),
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Teacher',
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Home
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text('Home', style: TextStyle(fontFamily: 'Teacher')),
            onTap: () => Navigator.pop(context),
          ),

          /// Settings
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.blue),
            title:
                const Text('Settings', style: TextStyle(fontFamily: 'Teacher')),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  OptionsScreen(),
                ),
              );
            },
          ),

          /// About
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blue),
            title: const Text('About', style: TextStyle(fontFamily: 'Teacher')),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutUsScreen(),
                ),
              );
            },
          ),

          const Divider(),

          /// Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(fontFamily: 'Teacher')),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }
}
