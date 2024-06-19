import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';

class FavoriteNotifier extends StateNotifier<List<Course>> {
  FavoriteNotifier() : super([]);

  bool favoriteStatus(Course course) {
    final isFavorite = state.contains(course);

    if (isFavorite) {
      state = state.where((c) => c.id != course.id).toList();
      _updateFavoritesInFirestore(course, remove: true);
      return false;
    } else {
      state = [...state, course];
      _updateFavoritesInFirestore(course);
      return true;
    }
  }

  Future<void> _updateFavoritesInFirestore(Course course, {bool remove = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

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

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<Course>>(
  (ref) => FavoriteNotifier(),
);
