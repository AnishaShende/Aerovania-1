import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Stores the video and assignment metadata in Firestore
class FileStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchAndStoreMetadata(String directory, String type) async {
    try {
      if (type != 'videos' && type != 'assignments') {
        throw ArgumentError('Type must be either "videos" or "assignments"');
      }

      // List all files in the directory
      ListResult result = await _firebaseStorage.ref(directory).listAll();
      print("result: $result, items: ${result.items}");

      for (var ref in result.items) {
        // Get download URL
        String downloadURL = await ref.getDownloadURL();
        String fileName = ref.name;

        // Determine the subcollection based on the type
        String subcollectionPath = '$type';

        // Check if the document exists in Firestore
        var docSnapshot = await _firestore
            .collection('course_1')
            .doc(
                'course_documents') // assuming a single document for simplicity
            .collection(subcollectionPath)
            .doc(fileName)
            .get();

        // If the document does not exist, add it
        if (!docSnapshot.exists) {
          await _firestore
              .collection('course_1')
              .doc(
                  'course_documents') // assuming a single document for simplicity
              .collection(subcollectionPath)
              .doc(fileName)
              .set({
            'name': fileName,
            'url': downloadURL,
            'timestamp': FieldValue.serverTimestamp(),
          });

          print(
              'Metadata for $fileName stored in Firestore under $subcollectionPath');
        }
      }
    } on FirebaseException catch (e) {
      print('Firebase Error: ${e.message}');
      if (e.code == 'too-many-requests') {
        // Implement retry logic here if necessary
        print('Too many requests. Please try again later.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

// function logic

// FileStorageService storageService = FileStorageService();

//             // Fetch and store videos metadata
//             await storageService.fetchAndStoreMetadata(
//                 'course_1/videos', 'videos');

//             // Fetch and store assignments metadata
//             await storageService.fetchAndStoreMetadata(
//                 'course_1/assignments', 'assignments');