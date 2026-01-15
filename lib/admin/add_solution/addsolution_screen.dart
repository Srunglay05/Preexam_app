import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AddSolutionScreen extends StatefulWidget {
  final String? solutionId;
  final String? existingTitle;
  final String? existingSubject;
  final String? existingPdfUrl;

  const AddSolutionScreen({
    super.key,
    this.solutionId,
    this.existingTitle,
    this.existingSubject,
    this.existingPdfUrl,
  });

  @override
  State<AddSolutionScreen> createState() => _AddSolutionScreenState();
}

class _AddSolutionScreenState extends State<AddSolutionScreen> {
  late TextEditingController solutionTitleController;
  File? selectedFile;
  String selectedSubject = 'Mathematics';
  String? existingPdfUrl;

  final List<String> subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Earth Science',
    'Morality',
    'History',
    'Geography',
    'Khmer Literature',
  ];

  @override
  void initState() {
    super.initState();
    solutionTitleController =
        TextEditingController(text: widget.existingTitle ?? '');
    selectedSubject = widget.existingSubject ?? 'Mathematics';
    existingPdfUrl = widget.existingPdfUrl;
  }

  Future<void> pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
          existingPdfUrl = null; // remove old PDF if user picks new one
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file: $e');
    }
  }

  Future<void> postSolution() async {
    if (solutionTitleController.text.isEmpty ||
        (selectedFile == null && existingPdfUrl == null)) {
      Get.snackbar('Error', 'Please add title and PDF');
      return;
    }

    try {
      String pdfUrl = existingPdfUrl ?? '';

      if (selectedFile != null) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${selectedFile!.path.split('/').last}';
        final storageRef = FirebaseStorage.instance.ref().child('solutions/$fileName');
        await storageRef.putFile(selectedFile!);
        pdfUrl = await storageRef.getDownloadURL();
      }

      final collection = FirebaseFirestore.instance.collection('solutions');

      if (widget.solutionId == null) {
        // Add new solution
        await collection.add({
          'title': solutionTitleController.text,
          'subject': selectedSubject,
          'pdfUrl': pdfUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });
        Get.snackbar('Success', 'Solution uploaded successfully!');
      } else {
        // Update existing solution
        await collection.doc(widget.solutionId).update({
          'title': solutionTitleController.text,
          'subject': selectedSubject,
          'pdfUrl': pdfUrl,
        });
        Get.snackbar('Success', 'Solution updated successfully!');
      }

      // Clear data after post/update
      solutionTitleController.clear();
      setState(() {
        selectedFile = null;
        existingPdfUrl = null;
        selectedSubject = 'Mathematics';
      });

      Get.back(); // Return to Admin screen
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload: $e');
      debugPrint('Upload error: $e');
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
          widget.solutionId == null ? 'Add Solution' : 'Edit Solution',
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
            colors: [Color(0xFFF5F7FB), Color(0xFF2196F3)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
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
                      const Text(
                        'Add New Solution',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Teacher',
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Select subject, add PDF and solution title',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Teacher',
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Subject Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F7FB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedSubject,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: const TextStyle(
                                fontFamily: 'Teacher',
                                fontSize: 16,
                                color: Colors.black),
                            items: subjects.map((subject) {
                              return DropdownMenuItem(
                                value: subject,
                                child: Text(subject,
                                    style: const TextStyle(
                                        fontFamily: 'Teacher')),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSubject = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // PDF Picker
                      GestureDetector(
                        onTap: pickPdf,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7FB),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: selectedFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: SfPdfViewer.file(selectedFile!),
                                )
                              : existingPdfUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child:
                                          SfPdfViewer.network(existingPdfUrl!),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.picture_as_pdf,
                                            size: 42, color: Colors.red),
                                        SizedBox(height: 10),
                                        Text(
                                          'Tap to add solution PDF',
                                          style: TextStyle(
                                              fontFamily: 'Teacher',
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Solution Title
                      TextField(
                        controller: solutionTitleController,
                        style: const TextStyle(fontFamily: 'Teacher'),
                        decoration: InputDecoration(
                          labelText: 'Solution Title',
                          labelStyle: const TextStyle(fontFamily: 'Teacher'),
                          filled: true,
                          fillColor: const Color(0xFFF6F7FB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Colors.grey.shade400),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
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
                              onPressed: postSolution,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2196F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                elevation: 4,
                              ),
                              child: Text(
                                widget.solutionId == null ? 'Post' : 'Update',
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
                    ],
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
    solutionTitleController.dispose();
    super.dispose();
  }
}
