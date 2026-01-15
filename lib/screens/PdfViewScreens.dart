import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreens extends StatelessWidget {
  final String title;
  final File file;

  const PdfViewScreens({super.key, required this.title, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SfPdfViewer.file(file),
    );
  }
}
