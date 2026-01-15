import 'dart:io';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SolutionController extends GetxController {
  var selectedFile = Rxn<File>();
  var solutionTitle = ''.obs;
  var selectedSubject = 'Mathematics'.obs;

  // Upload PDF
  Future<String?> uploadPdf() async {
    if (selectedFile.value == null) return null;

    try {
      final fileName = selectedFile.value!.path.split('/').last;
      final storageRef = FirebaseStorage.instance.ref('solutions/$fileName');
      await storageRef.putFile(selectedFile.value!);
      final pdfUrl = await storageRef.getDownloadURL();
      return pdfUrl;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  // Save to Firestore
  Future<void> saveSolution(String pdfUrl) async {
    await FirebaseFirestore.instance.collection('solutions').add({
      'title': solutionTitle.value,
      'subject': selectedSubject.value,
      'pdfUrl': pdfUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Clear data after post
  void clearData() {
    selectedFile.value = null;
    solutionTitle.value = '';
    selectedSubject.value = 'Mathematics';
  }
}
