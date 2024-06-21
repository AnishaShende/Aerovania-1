import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/course.dart';

class FavoriteState {
  final bool isLoading;
  final List<Course> courses;

  FavoriteState({required this.isLoading, required this.courses});
}

class FavoriteNotifier extends StateNotifier<FavoriteState> {
  FavoriteNotifier() : super(FavoriteState(isLoading: true, courses: [])) {
    _fetchBookmarkedCourses();
  }

  Future<void> _fetchBookmarkedCourses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = FavoriteState(isLoading: false, courses: []);
      return;
    }

    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    try {
      // print('Fetching bookmarked courses...');
      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists &&
          docSnapshot.data()!.containsKey('favoriteCourses')) {
        List<dynamic> favoriteCourseIds = docSnapshot.get('favoriteCourses');
        // print('Favorite course IDs: $favoriteCourseIds');
        List<Course> favoriteCourses = [];
        favoriteCourseIds = favoriteCourseIds.map((e) => e.toString()).toList();
        for (String courseId in favoriteCourseIds) {
          final course = await _fetchCourseById(courseId);
          if (course != null) {
            favoriteCourses.add(course);
            // print('added course: ${course.name}');
          }
        }
        // print('Favorite courses: $favoriteCourses');
        state = FavoriteState(isLoading: false, courses: favoriteCourses);
        // print('Favorite state: $state');
      } else {
        state = FavoriteState(isLoading: false, courses: []);
      }
    } catch (e) {
      print('Error fetching bookmarked courses: $e');
      state = FavoriteState(isLoading: false, courses: []);
    }
  }

  Future<Course?> _fetchCourseById(String courseId) async {
    try {
      final courseDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get();
      if (courseDoc.exists) {
        return Course.fromMap(courseDoc.data()!);
      }
    } catch (e) {
      print('Error fetching course by ID: $e');
    }
    return null;
  }

  bool favoriteStatus(Course course) {
    final isFavorite = state.courses.contains(course);

    if (isFavorite) {
      final updatedCourses =
          state.courses.where((c) => c.id != course.id).toList();
      state = FavoriteState(isLoading: false, courses: updatedCourses);
      _updateFavoritesInFirestore(course, remove: true);
      return false;
    } else {
      final updatedCourses = [...state.courses, course];
      state = FavoriteState(isLoading: false, courses: updatedCourses);
      _updateFavoritesInFirestore(course);
      return true;
    }
  }

  Future<void> _updateFavoritesInFirestore(Course course,
      {bool remove = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      if (remove) {
        await userDoc.update({
          'favoriteCourses': FieldValue.arrayRemove([course.id]),
        });
      } else {
        await userDoc.update({
          'favoriteCourses': FieldValue.arrayUnion([course.id]),
        });
      }
    } catch (e) {
      print('Error updating favorite courses: $e');
      throw Exception('Failed to update favorite courses');
    }
  }
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, FavoriteState>(
  (ref) => FavoriteNotifier(),
);
