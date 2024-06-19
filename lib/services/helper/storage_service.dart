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

  uploadCategories() async {
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
// Your categories data
    List<Map<String, String>> categories = [
      {"name": "All", "icon": "assets/icons/category/all.jpg"},
      {"name": "Coding", "icon": "assets/icons/category/coding.jpg"},
      {"name": "Education", "icon": "assets/icons/category/education.jpg"},
      {"name": "Design", "icon": "assets/icons/category/design.jpg"},
      {"name": "Business", "icon": "assets/icons/category/business.jpg"},
      {"name": "Finance", "icon": "assets/icons/category/finance.jpg"},
    ];

    // Initialize the categories collection
    CollectionReference categoriesCollection =
        _firestore.collection('categories');
    Map<String, String> categoryDocs = {};

    // Add the categories to the collection
    for (Map<String, String> category in categories) {
      DocumentReference docRef = await categoriesCollection.add(category);
      categoryDocs[category['name']!] = docRef.id;
    }

    // Fetch all courses
    QuerySnapshot coursesSnapshot =
        await _firestore.collection('courses').get();

    // Update categories with course IDs
    for (QueryDocumentSnapshot courseDoc in coursesSnapshot.docs) {
      String courseId = courseDoc.id;
      List<dynamic> courseCategories = courseDoc['category'];

      for (String categoryName in courseCategories) {
        if (categoryDocs.containsKey(categoryName)) {
          String categoryId = categoryDocs[categoryName]!;
          DocumentReference categoryRef = categoriesCollection.doc(categoryId);

          await categoryRef.update({
            'courses': FieldValue.arrayUnion([courseId])
          });
        }
      }
    }
    print('Categories updated with course IDs successfully');
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