import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfScreen extends StatefulWidget {
  final String pdfPath;

  const PdfScreen({super.key, required this.pdfPath});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  String? pdfUrl;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    pdfUrl =
        await FirebaseStorage.instance.ref(widget.pdfPath).getDownloadURL();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: pdfUrl != null
          ? PDFView(
              filePath: pdfUrl,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
