import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddSolutionScreen extends StatefulWidget {
  const AddSolutionScreen({super.key});

  @override
  State<AddSolutionScreen> createState() => _AddSolutionScreenState();
}

class _AddSolutionScreenState extends State<AddSolutionScreen> {
  final TextEditingController solutionTitleController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

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
      /// 🔵 BLUE APP BAR
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

      /// 🌈 GRADIENT BACKGROUND
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

            /// 🧾 CARD
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
                        /// TITLE
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
                          'Select subject, add image and solution',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: 'Teacher',
                          ),
                        ),

                        const SizedBox(height: 22),

                        /// SUBJECT DROPDOWN
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7FB),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedSubject,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              style: const TextStyle(
                                fontFamily: 'Teacher',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              items: subjects.map((subject) {
                                return DropdownMenuItem(
                                  value: subject,
                                  child: Text(
                                    subject,
                                    style: const TextStyle(
                                        fontFamily: 'Teacher'),
                                  ),
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

                        /// IMAGE PICKER
                        GestureDetector(
                          onTap: () async {
                            final XFile? image =
                                await _picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 75,
                            );
                            if (image != null) {
                              setState(() {
                                selectedImage = File(image.path);
                              });
                            }
                          },
                          child: Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F7FB),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: Colors.grey.shade300),
                            ),
                            child: selectedImage == null
                                ? Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.image_outlined,
                                          size: 42,
                                          color: Colors.grey),
                                      SizedBox(height: 10),
                                      Text(
                                        'Tap to add solution image',
                                        style: TextStyle(
                                          fontFamily: 'Teacher',
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// SOLUTION TITLE
                        TextField(
                          controller: solutionTitleController,
                          style:
                              const TextStyle(fontFamily: 'Teacher'),
                          decoration: InputDecoration(
                            labelText: 'Solution Title',
                            labelStyle: const TextStyle(
                                fontFamily: 'Teacher'),
                            filled: true,
                            fillColor: const Color(0xFFF6F7FB),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// ACTION BUTTONS
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Get.back(),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(
                                      color:
                                          Colors.grey.shade400),
                                  padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 14),
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
                                onPressed: () {
                                  if (solutionTitleController
                                          .text.isEmpty ||
                                      selectedImage == null) {
                                    Get.snackbar(
                                      'Error',
                                      'Please add title and image',
                                    );
                                    return;
                                  }

                                  debugPrint(
                                      'Subject: $selectedSubject');
                                  debugPrint(
                                      'Title: ${solutionTitleController.text}');
                                  debugPrint(
                                      'Image: ${selectedImage!.path}');

                                  Get.back();
                                },
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF2196F3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 14),
                                  elevation: 4,
                                ),
                                child: const Text(
                                  'Post',
                                  style: TextStyle(
                                    fontFamily: 'Teacher',
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
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
