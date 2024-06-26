import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../course_details.dart';
import '../course_items.dart';

class FilteredCoursesScreen extends StatelessWidget {
  final String category;
  final List<Course> courses;
  var filteredCourses;

  FilteredCoursesScreen({
    Key? key,
    required this.category,
    required this.courses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    // Filter the courses based on the selected category
    if (category == 'All') {
      filteredCourses = courses;
    } else {
      filteredCourses = courses.where((course) {
        return course.category.contains(category);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: filteredCourses.length,
        itemBuilder: (context, index) {
          final course = filteredCourses[index];
          return CourseItem(
            data: course,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CourseDetails(course: course, isPurchasedCourse: false),
              ));
            },
          );
        },
      ),
    );
  }
}
