import 'package:flutter/material.dart';
import 'package:prexam/admin/add_course/addcourse_screen.dart';
import 'package:prexam/admin/add_solution/addsolution_screen.dart';
import 'package:prexam/admin/add_task/addtask_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'option_button.dart';
import 'package:get/get.dart';
import 'package:prexam/admin/AdminCourseScreen.dart';

class OptionsScreen extends StatelessWidget {
  OptionsScreen({super.key});

  // 🔹 Scaffold key for drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // 🔹 Fetch admin data
  Future<Map<String, dynamic>> getAdminData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return {"username": "Admin", "profileUrl": ""};

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return {"username": "Admin", "profileUrl": ""};

    return {
      "username": doc['username'] ?? "Admin",
      "profileUrl": doc['profileUrl'] ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Teacher',
            ),
      ),
      child: Scaffold(
        key: _scaffoldKey, // ✅ Assign key to Scaffold
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: getAdminData(),
                  builder: (context, snapshot) {
                    final username = snapshot.data?['username'] ?? 'Admin';
                    final profileUrl = snapshot.data?['profileUrl'] ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: profileUrl.isNotEmpty
                              ? NetworkImage(profileUrl)
                              : null,
                          child: profileUrl.isEmpty
                              ? const Icon(Icons.person, size: 30)
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Administrator',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Get.offAllNamed('/login'); // or your login route
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),

                /// Header
                FutureBuilder<Map<String, dynamic>>(
                  future: getAdminData(),
                  builder: (context, snapshot) {
                    final username = snapshot.data?['username'] ?? 'Admin';
                    final profileUrl = snapshot.data?['profileUrl'] ?? '';

                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState?.openDrawer(); // ✅ open drawer
                          },
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: profileUrl.isNotEmpty
                                ? NetworkImage(profileUrl)
                                : null,
                            child: profileUrl.isEmpty
                                ? const Icon(Icons.person, size: 25)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Admin, $username',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.notifications_none),
                          onPressed: () {},
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 10),
                const Divider(thickness: 1.5, color: Colors.black),

                /// Illustration
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/images/timez.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(thickness: 1.5, color: Colors.black),
                const SizedBox(height: 10),

                /// Title
                const Center(
                  child: Text(
                    'Options',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(thickness: 1.5, color: Colors.black),
                const SizedBox(height: 20),

                /// Buttons
                OptionButton(
                  icon: Icons.assignment,
                  text: 'Add New Task',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTaskScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),

                OptionButton(
                  icon: Icons.lightbulb_outline,
                  text: 'Add New Solution',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddSolutionScreen()),
                    );
                  },
                ),
                const SizedBox(height: 14),

                OptionButton(
                  icon: Icons.menu_book,
                  text: 'Add New Course',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddCourseScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                OptionButton(
                icon: Icons.menu_book,
                text: 'Manage Courses',
                onPressed: () {
                  // Navigate to AdminCourseScreen
                  Get.to(() => const AdminCourseScreen());
                },
              ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
