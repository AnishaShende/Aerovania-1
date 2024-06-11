import 'package:aerovania_app_1/models/course.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteNotifier extends StateNotifier<List<Course>> {
  FavoriteNotifier() : super([]);

  bool favoriteStatus(Course course) {
    final isFavorite = state.contains(course);

    if (isFavorite) {
      state = state.where((c) => c.id != course.id).toList();
      return false;
    } else {
      state = [...state, course];
      return true;
    }
  }
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<Course>>(
  (ref) => FavoriteNotifier(),
);
