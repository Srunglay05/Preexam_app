import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  final String title;
  final String pdfUrl;

  const PdfViewScreen({super.key, required this.title, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Teacher',
            fontSize: 20,
          ),
        ),
      ),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}

class SolutionListScreen extends StatelessWidget {
  final String subjectTitle;

  const SolutionListScreen({
    super.key,
    required this.subjectTitle,
  });

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> solutionStream = FirebaseFirestore.instance
        .collection('solutions')
        .where('subject', isEqualTo: subjectTitle)
        .orderBy('createdAt', descending: true)
        .snapshots();

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
      body: StreamBuilder<QuerySnapshot>(
        stream: solutionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No PDFs available',
                style: TextStyle(
                  fontFamily: 'Teacher',
                  fontSize: 18,
                ),
              ),
            );
          }

          final solutions = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: solutions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final solution = solutions[index].data() as Map<String, dynamic>;
              final title = solution['title'] ?? 'Untitled';
              final pdfUrl = solution['pdfUrl'] ?? '';

              return Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    if (pdfUrl.isEmpty) {
                      Get.snackbar('No PDF', 'This solution has no PDF.');
                      return;
                    }

                    Get.to(() => PdfViewScreen(
                          title: title,
                          pdfUrl: pdfUrl,
                        ));
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
                        pdfUrl.isNotEmpty
                            ? const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red,
                                size: 32,
                              )
                            : const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.grey,
                                size: 32,
                              ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            title,
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
          );
        },
      ),
    );
  }
}
