import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/controllers/course_controller.dart';
import 'package:prexam/screens/pdf_viewer_page.dart';
class CourseListScreen extends StatelessWidget {
  CourseListScreen({super.key});

  final CourseController controller = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("High School Courses"),
        backgroundColor: Colors.blue.shade400,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: controller.courses.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final course = controller.courses[index];

            return GestureDetector(
              onTapDown: (_) => controller.zoomIn(index),
              onTapUp: (_) {
                controller.zoomOut();
                // Open PDF from assets using GetX
                 Get.to(() => PdfViewerPage(
                    pdfAsset: 'assets/pdfs/khmer.pdf', 
                    pdfWeb: 'https://sala.moeys.gov.kh/kh/library/download/512aeafa-abff-4fd2-a5c2-c7afdba81172.pdf',
                    title: 'អក្សរសាស្ត្រខ្មែរ ថ្នាក់ទី១២',
              ));
              },
              onTapCancel: () => controller.zoomOut(),
              child: Obx(
                () => AnimatedScale(
                  scale:
                      controller.selectedIndex.value == index ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // IMAGE
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                            child: Image.asset(
                              course.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // TEXT
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                course.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
