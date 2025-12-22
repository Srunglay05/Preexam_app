import 'package:get/get.dart';
import 'package:prexam/models/course.dart';
class CourseController extends GetxController {
  // Which card is zoomed
  var selectedIndex = (-1).obs;

  final courses = <Course>[
    const Course(name: "គណិតវិទ្យា​ថ្នាក់ទី១២", image: "assets/images/mathlogo.png", pdfUrl: "assets/pdfs/math.pdf",),
    const Course(name: "រូបវិទ្យា​ថ្នាក់​ទី១២", image: "assets/images/physics.png", pdfUrl: "assets/pdfs/math.pdf",),
    const Course(name: "ជីវិទ្យា​ថ្នាក់ទី១២", image: "assets/images/biology.png", pdfUrl: "assets/pdfs/math.pdf",),
    const Course(name: "គីមីវិទ្យា​ថ្នាក់ទី១២", image: "assets/images/chemistry.png", pdfUrl: "assets/pdfs/math.pdf",),
    const Course(name: "អក្សរសាស្ត្រខ្មែរ ថ្នាក់ទី១២", image: "assets/images/khmer.png",pdfUrl: "https://sala.moeys.gov.kh/kh/library/download/512aeafa-abff-4fd2-a5c2-c7afdba81172.pdf",),
    const Course(name: "ភូមិវិទ្យា​ថ្នាក់​ទី១២", image: "assets/images/geography.png", pdfUrl: "assets/pdfs/math.pdf",),
    const Course(name: "ប្រវត្តិវិទ្យា​ថ្នាក់ទី១២", image: "assets/images/history.png", pdfUrl: "assets/pdfs/math.pdf",),
    const Course(
       name: "ផែនដី និងបរិស្ថានវិទ្យា ថ្នាក់ទី១២",
      image: "assets/images/image.png",
       pdfUrl: "assets/pdfs/math.pdf",
    ),
  ].obs;

  // Zoom in
  void zoomIn(int index) {
    selectedIndex.value = index;
  }

  // Zoom out
  void zoomOut() {
    selectedIndex.value = -1;
  }
}
