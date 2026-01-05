import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/screens/result_screen.dart';
import 'package:prexam/widgets/scorewid.dart';
import '../controllers/score_controller.dart';
import '../controllers/result_controller.dart';

class ScoreInputPage extends StatefulWidget {
  const ScoreInputPage({super.key});

  @override
  State<ScoreInputPage> createState() => _ScoreInputPageState();
}

class _ScoreInputPageState extends State<ScoreInputPage>
    with SingleTickerProviderStateMixin {
  late final ScoreController scoreController;
  late final ResultController resultController;
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    // ✅ CONTROLLERS CREATED ONCE, IN ORDER
    scoreController = Get.put(ScoreController());
    resultController = Get.put(ResultController());

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        scoreController.selectedGroup.value =
            tabController.index == 0 ? 'science' : 'social';
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Calculate Score',
          style: TextStyle(fontFamily: 'Teacher', fontSize: 23),
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontFamily: 'Teacher',
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'Science'),
            Tab(text: 'Social'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: _subjectGrid()),
            const SizedBox(height: 12),

            // ✅ SAFE BUTTON
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  resultController.calculate();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResultScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Calculate',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Teacher',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subjectGrid() {
    return Obx(() {
      final subjects = scoreController.currentSubjects;
      return GridView.builder(
        itemCount: subjects.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, index) {
          final s = subjects[index];
          return SubjectCard(
            title: s['name'],
            max: s['max'],
            icon: s['icon'],
            value: s['value'],
          );
        },
      );
    });
  }
}
