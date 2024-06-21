import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/course.dart';
import '../providers/favorite_provider.dart';

class BookmarkBox extends ConsumerStatefulWidget {
  const BookmarkBox({Key? key, required this.course}) : super(key: key);
  final Course course;

  @override
  _BookmarkBoxState createState() => _BookmarkBoxState();
}

class _BookmarkBoxState extends ConsumerState<BookmarkBox> {
  @override
  Widget build(BuildContext context) {
    final favoriteState = ref.watch(favoriteProvider);
    final isFavorited = favoriteState.courses.contains(widget.course);

    if (favoriteState.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return IconButton(
      icon: Icon(
        isFavorited ? Icons.bookmark : Icons.bookmark_border,
      ),
      onPressed: () async {
        final wasAdded = await ref
            .read(favoriteProvider.notifier)
            .favoriteStatus(widget.course);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              wasAdded
                  ? 'Course added to favorites!'
                  : 'Course removed from favorites!',
            ),
          ),
        );
      },
    );
  }
}
