import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/controllers/nav_controller.dart';
import 'package:prexam/navi_drawer/drawer_menus.dart';
import 'package:prexam/screens/courses/coursescreen.dart';
import 'package:prexam/screens/pregrams/pregram_screen.dart';
import 'package:prexam/screens/reminder/reminder_list_page.dart';
import 'package:prexam/screens/score_input.dart';
import 'package:prexam/widgets/mainhome/bottom_nav.dart';
import 'package:prexam/widgets/mainhome/course_card.dart';
import 'package:prexam/widgets/mainhome/promo_card.dart';
import 'package:prexam/widgets/mainhome/searchbarwidget.dart';
import 'package:prexam/widgets/mainhome/task_menu.dart';
import 'package:prexam/widgets/mainhome/top_header.dart';
 
class HomeMainScreen extends StatelessWidget {
  HomeMainScreen({super.key});

  final NavController navController = Get.put(NavController());

  // ✅ ONE KEY ONLY
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      // ✅ ADD DRAWER
      drawer: const DrawerMenus(),

      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(),

      body: Obx(() {
        switch (navController.selectedIndex.value) {
          case 0:
            return mainHomeUI();
          case 1:
            return ReminderListPage();
          case 2:
            return PregramScreen();
          case 3:
            return ScoreInputPage();
          /*case 4:
            return const Center(child: Text("Profile Screen"));*/
          default:
            return mainHomeUI();
        }
      }),
    );
  }

  Widget mainHomeUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),

          // ✅ PASS SAME KEY
          TopHeader(scaffoldKey: scaffoldKey),

          const SizedBox(height: 20),
          SearchBarWidget(),
          const SizedBox(height: 18),
          TaskMenu(),
          const SizedBox(height: 15),
          PromoCard(),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Course",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Teacher',
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(() => const CourseScreen()),
                child: const Text(
                  "See All...",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                    fontFamily: 'Teacher',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CourseCard(),
        ],
      ),
    );
  }
}
