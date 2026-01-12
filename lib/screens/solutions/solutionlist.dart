import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/models/solution_pdf.dart';
import 'package:prexam/screens/pdfviewscreen.dart';

class SolutionListScreen extends StatelessWidget {
  final String subjectTitle;

  const SolutionListScreen({
    super.key,
    required this.subjectTitle,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ CORRECT static access
    final pdfList = SolutionPdfData.datas[subjectTitle] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          subjectTitle,
          style: const TextStyle(
            fontFamily: 'Teacher',
            fontSize: 23,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: pdfList.isEmpty
          ? const Center(
              child: Text(
                'No PDF available',
                style: TextStyle(
                  fontFamily: 'Teacher',
                  fontSize: 18,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pdfList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pdf = pdfList[index];

                return Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Get.to(
                        () => PdfViewScreen(
                          title: pdf['title']!,
                          assetPath: pdf['path']!,
                        ),
                      );
                    },
                    child: Container(
                      height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              pdf['title']!,
                              style: const TextStyle(
                                fontFamily: 'Teacher',
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
