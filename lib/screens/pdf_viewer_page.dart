import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  final String pdfAsset; // for Mobile
  final String pdfWeb;   // for Web
  final String title;

  const PdfViewerPage({
    super.key,
    required this.pdfAsset,
    required this.pdfWeb,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("========== PDF DEBUG ==========");
    debugPrint("Is Web        : $kIsWeb");
    debugPrint("PDF Asset     : $pdfAsset");
    debugPrint("PDF Web URL   : $pdfWeb");
    debugPrint("================================");

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: kIsWeb
          ? SfPdfViewer.network(
              pdfWeb,
              enableDoubleTapZooming: true,
              onDocumentLoaded: (details) {
                debugPrint("✅ PDF loaded successfully (WEB)");
              },
              onDocumentLoadFailed: (details) {
                debugPrint("❌ PDF load failed (WEB)");
                debugPrint("Error: ${details.error}");
                debugPrint("Description: ${details.description}");
              },
            )
          : SfPdfViewer.asset(
              pdfAsset,
              enableDoubleTapZooming: true,
              onDocumentLoaded: (details) {
                debugPrint("✅ PDF loaded successfully (MOBILE)");
              },
              onDocumentLoadFailed: (details) {
                debugPrint("❌ PDF load failed (MOBILE)");
                debugPrint("Error: ${details.error}");
                debugPrint("Description: ${details.description}");
              },
            ),
    );
  }
}
