import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSolutionScreen extends StatefulWidget {
  const AddSolutionScreen({super.key});

  @override
  State<AddSolutionScreen> createState() => _AddSolutionScreenState();
}

class _AddSolutionScreenState extends State<AddSolutionScreen> {
  final TextEditingController solutionTitleController = TextEditingController();
  File? selectedFile;

  String selectedSubject = 'Mathematics';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add Solution',
          style: TextStyle(
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
                        onTap: () async {
                          try {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );

                            if (result != null && result.files.single.path != null) {
                              setState(() {
                                selectedFile = File(result.files.single.path!);
                              });
                            }
                          } catch (e) {
                            Get.snackbar('Error', 'Failed to pick file: $e');
                          }
                        },
                        child: Container(
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7FB),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: selectedFile == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.picture_as_pdf,
                                        size: 42, color: Colors.red),
                                    SizedBox(height: 10),
                                    Text(
                                      'Tap to add solution PDF',
                                      style: TextStyle(
                                        fontFamily: 'Teacher',
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.picture_as_pdf,
                                        size: 42, color: Colors.red),
                                    const SizedBox(height: 10),
                                    Text(
                                      selectedFile!.path.split('/').last,
                                      style:
                                          const TextStyle(fontFamily: 'Teacher'),
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
                              onPressed: () async {
                                if (solutionTitleController.text.isEmpty ||
                                    selectedFile == null) {
                                  Get.snackbar(
                                      'Error', 'Please add title and PDF');
                                  return;
                                }

                                try {
                                  // Upload PDF to Firebase Storage
                                  final storageRef = FirebaseStorage.instance
                                      .ref()
                                      .child(
                                          'solutions/${selectedFile!.path.split('/').last}');
                                  final uploadTask =
                                      await storageRef.putFile(selectedFile!);
                                  final pdfUrl = await storageRef.getDownloadURL();

                                  // Save metadata to Firestore
                                  await FirebaseFirestore.instance
                                      .collection('solutions')
                                      .add({
                                    'title': solutionTitleController.text,
                                    'subject': selectedSubject,
                                    'pdfUrl': pdfUrl,
                                    'createdAt': FieldValue.serverTimestamp(),
                                  });

                                  Get.snackbar(
                                      'Success', 'Solution uploaded successfully!');
                                  Get.back();
                                } catch (e) {
                                  Get.snackbar('Error', 'Failed to upload: $e');
                                  debugPrint('Upload error: $e');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2196F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                elevation: 4,
                              ),
                              child: const Text(
                                'Post',
                                style: TextStyle(
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
