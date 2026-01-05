import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/result_controller.dart';

class ResultScreen extends GetView<ResultController> {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.blue,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // ---------- GRADE CIRCLE ----------
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(85),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          controller.grade.value,
                          style: const TextStyle(
                            fontFamily: 'Teacher',
                            fontSize: 110, 
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ---------- GRADE TEXT ----------
                      Text(
                        'Grade ${controller.grade.value}',
                        style: const TextStyle(
                          fontFamily: 'Teacher',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ---------- RESULT SUMMARY ----------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      controller.isPass ? 'PASS' : 'FAIL',
                      style: TextStyle(
                        fontFamily: 'Teacher',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            controller.isPass ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Score: ${controller.rawScore}/${controller.maxTotal}',
                      style: const TextStyle(
                        fontFamily: 'Teacher',
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Percentage: ${controller.percent.value.toStringAsFixed(2)}%',
                      style: const TextStyle(
                        fontFamily: 'Teacher',
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---------- SUBJECT LIST ----------
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final s = controller.subjects[i];
                  return ListTile(
                    title: Text(
                      s['name'],
                      style: const TextStyle(
                        fontFamily: 'Teacher',
                        fontSize: 18, // 👈 bigger subject name
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Text(
                      '${s['value'].value} / ${s['max']}',
                      style: const TextStyle(
                        fontFamily: 'Teacher',
                        fontSize: 18, // 👈 bigger score
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
                childCount: controller.subjects.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
