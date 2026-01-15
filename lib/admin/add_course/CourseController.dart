import 'dart:io';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseController extends GetxController {
  // New PDF picked from device
  var selectedPdf = Rxn<File>();

  // Existing PDF URL (for edit mode)
  var selectedPdfUrl = ''.obs;

  // Course title
  var courseTitle = ''.obs;

  // Subject (if applicable)
  var selectedSubject = ''.obs;

  // Dropdown course
  var selectedCourse = 'Pre-Doctor Examination'.obs;

  // Upload PDF to Firebase and return URL
  Future<String?> uploadPdf() async {
    // If new file picked, upload it
    if (selectedPdf.value != null) {
      try {
        final fileName = selectedPdf.value!.path.split('/').last;
        final storageRef = FirebaseStorage.instance.ref('courses/$fileName');
        await storageRef.putFile(selectedPdf.value!);
        final pdfUrl = await storageRef.getDownloadURL();
        return pdfUrl;
      } catch (e) {
        print('Upload error: $e');
        return null;
      }
    }

    // Otherwise, return existing URL
    if (selectedPdfUrl.value.isNotEmpty) {
      return selectedPdfUrl.value;
    }

    return null;
  }

  // Clear all data
  void clearData() {
    selectedPdf.value = null;
    selectedPdfUrl.value = '';
    courseTitle.value = '';
    selectedSubject.value = '';
    selectedCourse.value = 'Pre-Doctor Examination';
  }
}
