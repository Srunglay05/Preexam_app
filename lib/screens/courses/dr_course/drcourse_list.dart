import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/screens/pdfviewscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorListScreen extends StatelessWidget {
  final String subjectTitle;

  const DoctorListScreen({
    super.key,
    required this.subjectTitle,
  });

  @override
  Widget build(BuildContext context) {
    // Reference Firestore "courses" collection
    final CollectionReference coursesCollection =
        FirebaseFirestore.instance.collection('courses');

    return Scaffold(
      backgroundColor: Colors.white,

      /// 🟦 APP BAR
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

      /// 📄 PDF LIST
      body: StreamBuilder<QuerySnapshot>(
        // ✅ Fetch Pre-Doctor PDFs filtered by subject
        stream: coursesCollection
        .where('courseType', isEqualTo: 'Pre-Doctor Examination')
        .where('subjectTitle', isEqualTo: subjectTitle) // use this instead of 'title'
        .orderBy('createdAt', descending: true)
        .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show message if no PDFs
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No PDF available',
                style: TextStyle(
                  fontFamily: 'Teacher',
                  fontSize: 18,
                ),
              ),
            );
          }

          final pdfList = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: pdfList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final pdf = pdfList[index];

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Open PDF
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
                          pdf['title'],
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
