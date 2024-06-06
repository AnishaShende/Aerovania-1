import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Stores the video metadata in Firestore
class FileStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchAndStoreMetadata(String directory) async {
    try {
      // List all files in the directory
      ListResult result = await _firebaseStorage.ref(directory).listAll();
      print("result: $result, items: ${result.items}");

      for (var ref in result.items) {
        // Get download URL
        String downloadURL = await ref.getDownloadURL();
        String fileName = ref.name;

// Check if the document exists in Firestore
        var docSnapshot =
            await _firestore.collection('course_1').doc(fileName).get();

        // If the document does not exist, add it
        if (!docSnapshot.exists) {
          await _firestore.collection('course_1').doc(fileName).set({
            'name': fileName,
            'url': downloadURL,
            'timestamp': FieldValue.serverTimestamp(),
          });

          print('Metadata for $fileName stored in Firestore');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
