import 'package:get/get.dart';
import 'score_controller.dart';

class ResultController extends GetxController {
  late final ScoreController scoreController;

  @override
  void onInit() {
    super.onInit();
    // ✅ SAFE INITIALIZATION
    scoreController = Get.find<ScoreController>();
  }

  final rawScore = 0.obs;
  final maxTotal = 0.obs;
  final baciiScore = 0.obs;
  final percent = 0.0.obs;
  final grade = ''.obs;

  bool get isPass => grade.value != 'F';

  List<Map<String, dynamic>> get subjects =>
      scoreController.currentSubjects;

  void calculate() {
    int total = 0;
    int max = 0;

    for (var s in subjects) {
      final int maxScore = s['max'] as int;
      int score = int.tryParse(s['value'].value) ?? 0;

      if (score > maxScore) score = maxScore;

      if (s['name'] == 'English Literature') {
        score = score > 25 ? score - 25 : 0;
      }

      total += score;
      max += maxScore;
    }

    rawScore.value = total;
    maxTotal.value = max;

    if (max == 0) {
      percent.value = 0;
      baciiScore.value = 0;
      grade.value = 'F';
      return;
    }

    percent.value = (total / max) * 100;
    baciiScore.value = ((total / max) * 475).round();

    if (baciiScore.value >= 427) {
      grade.value = 'A';
    } else if (baciiScore.value >= 380) {
      grade.value = 'B';
    } else if (baciiScore.value >= 332) {
      grade.value = 'C';
    } else if (baciiScore.value >= 285) {
      grade.value = 'D';
    } else if (baciiScore.value >= 237) {
      grade.value = 'E';
    } else {
      grade.value = 'F';
    }
  }
}
