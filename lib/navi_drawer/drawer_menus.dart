import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'wave_clipper.dart';
import 'package:prexam/widgets/loginwid.dart'; // make sure to import your login page
import 'package:prexam/screens/login.dart';

class DrawerMenus extends StatefulWidget {
  const DrawerMenus({super.key});

  @override
  State<DrawerMenus> createState() => _DrawerMenusState();
}

class _DrawerMenusState extends State<DrawerMenus> {
  String username = 'User';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        email = user.email ?? '';
      });

      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists && doc.data()!.containsKey('username')) {
          setState(() {
            username = doc['username'];
          });
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    // 1️⃣ Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // 2️⃣ Clear saved login info from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 3️⃣ Navigate to Login page and remove all previous routes
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
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
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40),
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
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text('Home', style: TextStyle(fontFamily: 'Teacher')),
            onTap: () => Navigator.pop(context),
          ),
          const ListTile(
            leading: Icon(Icons.settings, color: Colors.blue),
            title: Text('Settings', style: TextStyle(fontFamily: 'Teacher')),
          ),
          const ListTile(
            leading: Icon(Icons.info, color: Colors.blue),
            title: Text('About', style: TextStyle(fontFamily: 'Teacher')),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(fontFamily: 'Teacher')),
            onTap: () => logout(context), // ✅ Use the logout function
          ),
        ],
      ),
    );
  }
}
