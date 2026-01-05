import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ScoreController extends GetxController {
  // ---------- VALUES (EMPTY BY DEFAULT) ----------
  RxString khmer = ''.obs;
  RxString math = ''.obs;
  RxString physics = ''.obs;
  RxString chemistry = ''.obs;
  RxString biology = ''.obs;

  RxString history = ''.obs;
  RxString geography = ''.obs;
  RxString morality = ''.obs;
  RxString english = ''.obs;
  RxString earth = ''.obs;

  RxString selectedGroup = 'science'.obs;

  Map<String, dynamic> subject(
    String name,
    int max,
    RxString value,
    IconData icon,
  ) {
    return {
      'name': name,
      'max': max,
      'value': value,
      'icon': icon,
    };
  }

  // ---------- SCIENCE ----------
  List<Map<String, dynamic>> get scienceSubjects => [
        subject('Mathematics', 125, math, Icons.calculate),
        subject('Khmer Literature', 75, khmer, Icons.book),
        subject('Physics', 75, physics, Icons.bolt),
        subject('Chemistry', 75, chemistry, Icons.science),
        subject('Biology', 75, biology, Icons.biotech),
        subject('English Literature', 50, english, Icons.abc),
        subject('History', 75, history, Icons.history_edu),
      ];

  // ---------- SOCIAL ----------
  List<Map<String, dynamic>> get socialSubjects => [
        subject('Khmer Literature', 125, khmer, Icons.book),
        subject('History', 75, history, Icons.history_edu),
        subject('Geography', 75, geography, Icons.public),
        subject('Earth Science', 75, earth, Icons.landscape),
        subject('Morality', 75, morality, Icons.balance),
        subject('English Literature', 50, english, Icons.abc),
        subject('Mathematics', 75, math, Icons.calculate),
      ];

  // ---------- CURRENT ----------
  List<Map<String, dynamic>> get currentSubjects =>
      selectedGroup.value == 'science' ? scienceSubjects : socialSubjects;
}
