import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> showAddTaskDialog({
  required BuildContext context,
  required String category,
  required String subject,
  VoidCallback? onPost,
}) async {
  final TextEditingController titleController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  File? selectedImage;
  Uint8List? webImageBytes;

  // 🔹 Upload image to Firebase Storage (Web + Mobile)
  Future<String> uploadImage() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('task_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    if (kIsWeb) {
      await ref.putData(webImageBytes!);
    } else {
      await ref.putFile(selectedImage!);
    }

    return await ref.getDownloadURL();
  }

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final size = MediaQuery.of(context).size;

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: size.height * 0.75),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    // 🔹 Title
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

                    // 🔹 Image Picker
                    InkWell(
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 70,
                        );

                        if (image != null) {
                          if (kIsWeb) {
                            webImageBytes = await image.readAsBytes();
                          } else {
                            selectedImage = File(image.path);
                          }
                          setState(() {});
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: (selectedImage == null &&
                                webImageBytes == null)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.image_outlined,
                                      size: 44, color: Colors.grey),
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
                                borderRadius: BorderRadius.circular(16),
                                child: kIsWeb
                                    ? Image.memory(
                                        webImageBytes!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                              side: BorderSide(
                                  color: Colors.grey.shade400),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (titleController.text.trim().isEmpty ||
                                  (selectedImage == null &&
                                      webImageBytes == null)) {
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

                              final imageUrl = await uploadImage();
                              final uid = FirebaseAuth
                                  .instance.currentUser!.uid;

                              // 🔹 Save task to Firestore
                              await FirebaseFirestore.instance
                                  .collection('tasks')
                                  .add({
                                'title':
                                    titleController.text.trim(),
                                'category': category.trim(),
                                'subject': subject.trim(), // ✅ IMPORTANT
                                'addedBy': uid,
                                'imageUrl': imageUrl, // ✅ correct field
                                'createdAt':
                                    FieldValue.serverTimestamp(),
                              });

                              if (onPost != null) onPost();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
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
