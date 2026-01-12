import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);

  final NavController navController = Get.put(NavController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: navController.selectedIndex.value,
        onTap: (i) => navController.changeIndex(i),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Reminder"),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper_sharp), label: "Pregram"),
          BottomNavigationBarItem(icon: Icon(Icons.calculate_sharp), label: "Calculate"),
          //BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          
        ],
      ),
    );
  }
}
