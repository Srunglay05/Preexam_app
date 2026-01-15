import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prexam/screens/pdfviewscreen.dart';




class IFLListScreen extends StatelessWidget {
  final String subjectTitle;

  const IFLListScreen({super.key, required this.subjectTitle});

  @override
  Widget build(BuildContext context) {
    final coursesCollection = FirebaseFirestore.instance.collection('courses');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
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
        stream: coursesCollection.snapshots(),
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
                  color: Colors.black54,
                ),
              ),
            );
          }

          // Filter PDFs by subjectTitle (course title)
          final pdfList = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final title = data['title']?.toString().toLowerCase().trim();
            final searchTitle = subjectTitle.toLowerCase().trim();
            return title == searchTitle;
          }).toList();

          // Sort PDFs by creation time
          pdfList.sort((a, b) {
            final aTime = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
            final bTime = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime);
          });

          if (pdfList.isEmpty) {
            return const Center(
              child: Text(
                'No PDFs available',
                style: TextStyle(
                  fontFamily: 'Teacher',
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: pdfList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final pdf = pdfList[index].data() as Map<String, dynamic>;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(() => PdfViewScreen(
                      title: pdf['title'] ?? 'Untitled',
                      pdfUrl: pdf['pdfUrl'] ?? '',
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
                      const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          pdf['title'] ?? '',
                          style: const TextStyle(
                            fontFamily: 'Teacher',
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ],
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
