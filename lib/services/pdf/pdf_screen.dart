import 'dart:async'; // Import dart:async to use the Completer class
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfScreen extends StatefulWidget {
  final String pdfPath;

  const PdfScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  String? pdfUrl;
  var newPdfUrl;
  var fileName;
  bool isLoading = true; // Track loading state
  int? pages; // Define pages to store the total number of pages
  bool isReady =
      false; // Define isReady to track if PDF is ready to be displayed
  final Completer<PDFViewController> _controller = Completer<
      PDFViewController>(); // Define a Completer for PDFViewController
  late Future<void> _loadPdfFuture;

  @override
  void initState() {
    super.initState();
    _loadPdfFuture = loadPdf();
    // _loadPdf();
  }

  loadPdf() async {
    setState(() {
      isLoading = true; // Indicate that loading has started
    });

    try {
      // Fetch the document from Firestore
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('course_1')
          .doc('course_documents')
          .collection('assignments')
          .doc(widget.pdfPath)
          .get();

      // Retrieve the URL from the document field
      if (docSnapshot.exists) {
        // setState(() async {
        pdfUrl = docSnapshot['url'];
        fileName = docSnapshot['name'];
        final response = await http.get(Uri.parse(pdfUrl!));
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$fileName');

        // Save the PDF file locally
        await file.writeAsBytes(bytes);
        newPdfUrl = file.path;
        print('newPdfUrl: $newPdfUrl');
        setState(() {
          isLoading = false; // Set loading state to false on error
        });
        displayPdf(newPdfUrl);
        // isLoading = false; // Set loading state to false when PDF is loaded
        // });
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching PDF URL: $e');
      setState(() {
        isLoading = false; // Set loading state to false on error
      });
    }
    setState(() {
      isLoading = false; // Set loading state to false on error
    });
  }

  Widget displayPdf(String pdfUrl) {
    if (!isLoading)
      return PDFView(
        filePath: pdfUrl,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
        onRender: (_pages) {
          setState(() {
            pages = _pages;
            isReady = true;
          });
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          _controller.complete(pdfViewController);
        },
        onPageChanged: (int? page, int? total) {
          // Correct the parameter types to nullable int
          print('page change: $page/$total');
        },
        //     ),
        // ],
      );
    else {
      return Center(child: CircularProgressIndicator());
    }
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: FutureBuilder(
        future: _loadPdfFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading PDF'));
          } else {
            return displayPdf(newPdfUrl);
          }
        },
      ),
    );
  }
}
