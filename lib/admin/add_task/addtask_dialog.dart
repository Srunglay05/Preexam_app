import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showAddTaskDialog({
  required BuildContext context,
  required String category,
  required String subject,
}) async {
  final TextEditingController titleController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? selectedImage;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final Size size = MediaQuery.of(context).size;

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white, // ✅ white background
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: size.height * 0.75, // ✅ not too tall
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // ✅ content-sized
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    const Text(
                      'Add Task',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Teacher',
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'Teacher',
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// TASK TITLE
                    TextField(
                      controller: titleController,
                      style: const TextStyle(fontFamily: 'Teacher'),
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        labelStyle:
                            const TextStyle(fontFamily: 'Teacher'),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// IMAGE PICKER
                    InkWell(
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 70,
                        );

                        if (image != null) {
                          setState(() {
                            selectedImage = File(image.path);
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 160, // ✅ fixed, not huge
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey.shade100,
                          border:
                              Border.all(color: Colors.grey.shade300),
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
                                    'Tap to add image',
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

                    const SizedBox(height: 24),

                    /// ACTION BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                  color: Colors.grey.shade400),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (titleController.text.isEmpty ||
                                  selectedImage == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please add title and image',
                                      style: TextStyle(
                                          fontFamily: 'Teacher'),
                                    ),
                                  ),
                                );
                                return;
                              }

                              debugPrint('Category: $category');
                              debugPrint('Subject: $subject');
                              debugPrint(
                                  'Title: ${titleController.text}');
                              debugPrint(
                                  'Image: ${selectedImage!.path}');

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 14),
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
          );
        },
      );
    },
  );
}
