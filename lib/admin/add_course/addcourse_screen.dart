import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  String selectedCourse = 'Pre-Doctor Examination';

  final List<String> courses = [
    'Pre-Doctor Examination',
    'Pre-IFL Examination',
    'Pre-RUPP Examination',
  ];

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🔵 BLUE APP BAR
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add Course',
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
                          'Add New Course',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Teacher',
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Select course and upload image',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: 'Teacher',
                          ),
                        ),

                        const SizedBox(height: 22),

                        /// 🔽 COURSE DROPDOWN
                        Container(
                          height: 56,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7FB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCourse,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 26,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Teacher',
                                fontSize: 17,
                                color: Colors.black,
                              ),
                              items: courses.map((course) {
                                return DropdownMenuItem(
                                  value: course,
                                  child: Text(
                                    course,
                                    style: const TextStyle(
                                      fontFamily: 'Teacher',
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCourse = value!;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🖼️ IMAGE PICKER
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
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withOpacity(0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: selectedImage == null
                                ? Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.image_outlined,
                                        size: 44,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Tap to add course image',
                                        style: TextStyle(
                                          fontFamily: 'Teacher',
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
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
                                    borderRadius:
                                        BorderRadius.circular(14),
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
                                  if (selectedImage == null) {
                                    Get.snackbar(
                                      'Error',
                                      'Please upload course image',
                                    );
                                    return;
                                  }

                                  debugPrint(
                                      'Course: $selectedCourse');
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
                                        BorderRadius.circular(14),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 14),
                                  elevation: 4,
                                ),
                                child: const Text(
                                  'Add Course',
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
}
