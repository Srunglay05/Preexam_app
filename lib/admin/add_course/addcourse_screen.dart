import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'CourseController.dart';

class AddCourseScreen extends StatefulWidget {
  final String? editCourseId;    // For editing
  final String? editTitle;       // Existing title
  final String? editCourseType;  // Existing course type
  final String? editPdfUrl;      // Existing PDF URL

  const AddCourseScreen({
    super.key,
    this.editCourseId,
    this.editTitle,
    this.editCourseType,
    this.editPdfUrl,
  });

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final CourseController courseController = Get.put(CourseController());
  final TextEditingController titleController = TextEditingController();

  final List<String> courses = [
    'Pre-Doctor Examination',
    'Pre-IFL Examination',
    'Pre-RUPP Examination',
  ];

  final Map<String, List<String>> subjectsMap = {
    'Pre-Doctor Examination': ['Physics', 'Biology', 'Mathematics', 'Chemistry'],
    'Pre-RUPP Examination': ['Physics', 'Biology', 'Mathematics', 'Chemistry'],
  };

  @override
  void initState() {
    super.initState();
    if (widget.editCourseId != null) {
      loadCourseData(); // Load existing course data for editing
    }
  }

  Future<void> loadCourseData() async {
    final doc = await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.editCourseId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      titleController.text = data['title'] ?? '';
      courseController.selectedCourse.value = data['courseType'] ?? '';
      courseController.selectedSubject.value = data['subjectTitle'] ?? '';
      courseController.selectedPdf.value = null; // No new file selected yet
      courseController.selectedPdfUrl.value = data['pdfUrl'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.editCourseId != null ? 'Edit Course' : 'Add Course',
          style: const TextStyle(
            fontFamily: 'Teacher',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F7FB),
              Color(0xFF2196F3),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.editCourseId != null
                              ? 'Edit Course'
                              : 'Add New Course',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Teacher',
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Select course, add title and PDF',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: 'Teacher',
                          ),
                        ),
                        const SizedBox(height: 22),

                        /// COURSE DROPDOWN
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7FB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Obx(() => DropdownButton<String>(
                                  value: courseController.selectedCourse.value.isEmpty
                                      ? null
                                      : courseController.selectedCourse.value,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down, size: 26),
                                  style: const TextStyle(
                                    fontFamily: 'Teacher',
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                  hint: const Text(
                                    'Select Course',
                                    style: TextStyle(fontFamily: 'Teacher', color: Colors.grey),
                                  ),
                                  items: courses.map((course) {
                                    return DropdownMenuItem(
                                      value: course,
                                      child: Text(course, style: const TextStyle(fontFamily: 'Teacher')),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      courseController.selectedCourse.value = value;
                                      courseController.selectedSubject.value = '';
                                    }
                                  },
                                )),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// SUBJECT DROPDOWN
                        Obx(() {
                          final course = courseController.selectedCourse.value;
                          if (course == 'Pre-Doctor Examination' || course == 'Pre-RUPP Examination') {
                            final subjects = subjectsMap[course] ?? [];
                            return Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F7FB),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: courseController.selectedSubject.value.isEmpty
                                      ? null
                                      : courseController.selectedSubject.value,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down, size: 26),
                                  style: const TextStyle(
                                    fontFamily: 'Teacher',
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                  hint: const Text(
                                    'Select Subject',
                                    style: TextStyle(fontFamily: 'Teacher', color: Colors.grey),
                                  ),
                                  items: subjects.map((subject) {
                                    return DropdownMenuItem(
                                      value: subject,
                                      child: Text(subject, style: const TextStyle(fontFamily: 'Teacher')),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      courseController.selectedSubject.value = value;
                                    }
                                  },
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),

                        const SizedBox(height: 20),

                        /// COURSE TITLE
                        TextField(
                          controller: titleController,
                          style: const TextStyle(fontFamily: 'Teacher'),
                          decoration: InputDecoration(
                            labelText: 'Course Title',
                            labelStyle: const TextStyle(fontFamily: 'Teacher'),
                            filled: true,
                            fillColor: const Color(0xFFF6F7FB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// PDF PICKER
                        GestureDetector(
                          onTap: () async {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if (result != null && result.files.single.path != null) {
                              courseController.selectedPdf.value = File(result.files.single.path!);
                              courseController.selectedPdfUrl.value = ''; // Clear existing URL if new PDF selected
                            }
                          },
                          child: Obx(
                            () => Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F7FB),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: courseController.selectedPdf.value != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: SfPdfViewer.file(
                                          courseController.selectedPdf.value!,
                                          canShowScrollHead: false,
                                          canShowScrollStatus: false),
                                    )
                                  : courseController.selectedPdfUrl.value.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: SfPdfViewer.network(
                                              courseController.selectedPdfUrl.value,
                                              canShowScrollHead: false,
                                              canShowScrollStatus: false),
                                        )
                                      : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.picture_as_pdf, size: 42, color: Colors.red),
                                            SizedBox(height: 10),
                                            Text(
                                              'Tap to add course PDF',
                                              style: TextStyle(
                                                fontFamily: 'Teacher',
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// ACTION BUTTONS
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Get.back(),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  side: BorderSide(color: Colors.grey.shade400),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'Teacher',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (titleController.text.isEmpty ||
                                      (courseController.selectedPdf.value == null &&
                                          courseController.selectedPdfUrl.value.isEmpty) ||
                                      ((courseController.selectedCourse.value ==
                                                  'Pre-Doctor Examination' ||
                                              courseController.selectedCourse.value ==
                                                  'Pre-RUPP Examination') &&
                                          courseController.selectedSubject.value.isEmpty)) {
                                    Get.snackbar('Error', 'Please add title, subject (if needed), and PDF');
                                    return;
                                  }

                                  // Upload PDF if new file selected
                                  String pdfUrl = courseController.selectedPdfUrl.value;
                                  if (courseController.selectedPdf.value != null) {
                                    final uploaded = await courseController.uploadPdf();
                                    if (uploaded != null) pdfUrl = uploaded;
                                  }

                                  if (widget.editCourseId != null) {
                                    // Update existing course
                                    await FirebaseFirestore.instance
                                        .collection('courses')
                                        .doc(widget.editCourseId)
                                        .update({
                                      'title': titleController.text,
                                      'courseType': courseController.selectedCourse.value,
                                      'subjectTitle': courseController.selectedSubject.value.isEmpty
                                          ? null
                                          : courseController.selectedSubject.value,
                                      'pdfUrl': pdfUrl,
                                    });
                                    Get.snackbar('Success', 'Course updated');
                                  } else {
                                    // Add new course
                                    await FirebaseFirestore.instance.collection('courses').add({
                                      'title': titleController.text,
                                      'courseType': courseController.selectedCourse.value,
                                      'subjectTitle': courseController.selectedSubject.value.isEmpty
                                          ? null
                                          : courseController.selectedSubject.value,
                                      'pdfUrl': pdfUrl,
                                      'createdAt': FieldValue.serverTimestamp(),
                                    });
                                    Get.snackbar('Success', 'Course added successfully');
                                  }

                                  courseController.clearData();
                                  titleController.clear();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2196F3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  elevation: 4,
                                ),
                                child: Text(
                                  widget.editCourseId != null ? 'Update' : 'Post',
                                  style: const TextStyle(
                                    fontFamily: 'Teacher',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        /// DELETE BUTTON
                        if (widget.editCourseId != null) ...[
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('courses')
                                  .doc(widget.editCourseId)
                                  .delete();
                              courseController.clearData();
                              titleController.clear();
                              Get.back();
                              Get.snackbar('Success', 'Course deleted');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Delete Course',
                              style: TextStyle(
                                fontFamily: 'Teacher',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ]
                      ],
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

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
