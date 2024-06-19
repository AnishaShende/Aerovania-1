import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/course.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      return doc.data() as Map<String, dynamic>;
    } on FirebaseException catch (e) {
      // Consider using a logging framework or service
      print('Error getting user data: ${e.message}');
      throw Exception('Failed to get user data');
    }
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(userId).update(data);
    } on FirebaseException catch (e) {
      print('Error updating user data: ${e.message}');
      throw Exception('Failed to update user data');
    }
  }
  // Function for storing courses in the firebase database
  // Future<void> storeCourses() async {
  //   for (Course course in courses) {
  //     await _db
  //         .collection('courses')
  //         .doc(course.id.toString())
  //         .set(course.toMap());
  //   }
  // }

  Future<void> uploadBookmarkedData(
      String userId, List<String> bookmarkedData) async {
    try {
      await _db.collection('users').doc(userId).update({
        'bookmarkedData': FieldValue.arrayUnion(bookmarkedData),
      });
    } on FirebaseException catch (e) {
      print('Error uploading bookmarked data: ${e.message}');
      throw Exception('Failed to upload bookmarked data');
    }
  }

  Future<void> uploadPurchasedCourses(
      String userId, List<String> courseIds) async {
    try {
      await _db.collection('users').doc(userId).update({
        'purchasedCourses': FieldValue.arrayUnion(courseIds),
      });
    } catch (e) {
      print('Error uploading purchased courses: $e');
      throw Exception('Failed to upload purchased courses');
    }
  }

  Stream<List<Course>> getPurchasedCoursesStream() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return _db
        .collection('users')
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
      List<dynamic> courseIds = userDoc.data()?['purchasedCourses'] ?? [];
      List<Course> courses = [];
      for (String courseId in courseIds) {
        DocumentSnapshot courseDoc =
            await _db.collection('courses').doc(courseId).get();
        if (courseDoc.exists) {
          courses.add(Course.fromMap(courseDoc.data() as Map<String, dynamic>));
        }
      }
      return courses;
    });
  }

  Future<void> uploadFavoriteCourses(
      String userId, List<String> courseIds) async {
    try {
      await _db.collection('users').doc(userId).update({
        'favoriteCourses': FieldValue.arrayUnion(courseIds),
      });
    } catch (e) {
      print('Error uploading favorite courses: $e');
      throw Exception('Failed to upload favorite courses');
    }
  }

  Stream<List<Course>> getFavoriteCoursesStream() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return _db
        .collection('users')
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
      List<dynamic> courseIds = userDoc.data()?['favoriteCourses'] ?? [];
      List<Course> courses = [];
      for (String courseId in courseIds) {
        DocumentSnapshot courseDoc =
            await _db.collection('courses').doc(courseId).get();
        if (courseDoc.exists) {
          courses.add(Course.fromMap(courseDoc.data() as Map<String, dynamic>));
        }
      }
      return courses;
    });
  }
}
