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
    return IconButton(
      icon: Icon(
        widget.course.isFavorited ? Icons.bookmark : Icons.bookmark_border,
      ),
      onPressed: () {
        final wasAdded =
            ref.read(favoriteProvider.notifier).favoriteStatus(widget.course);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(wasAdded
                ? 'Course added to favorites!'
                : 'Course removed from favorites!')));
      },
    );
  }
}
