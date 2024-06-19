import 'package:aerovania_app_1/Pages/course_details.dart';
import 'package:flutter/material.dart';
import 'package:aerovania_app_1/components/color.dart';
import 'package:aerovania_app_1/models/course.dart';
import '../../services/helper/firebase_services.dart';
import '../course_items.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key, required this.userId}) : super(key: key);
  final String userId; // Add userId to the widget

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  final FirebaseService _firebaseService = FirebaseService();
  late Stream<List<Course>> coursesStream;

  @override
  void initState() {
    super.initState();
    coursesStream = _firebaseService.getPurchasedCoursesStream();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffbfe0f8),
        body: StreamBuilder<List<Course>>(
          stream: coursesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<Course>? courses = snapshot.data;

            if (courses == null || courses.isEmpty) {
              return Center(child: Text('No courses found.'));
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: const Color(0xffbfe0f8),
                    pinned: true,
                    title: getAppBar(),
                    leading: IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu, color: Colors.black),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Course course = courses[index];
                        return CourseItem(
                          data: course,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CourseDetails(course: course),
                            ));
                          },
                        );
                      },
                      childCount: courses.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getAppBar() {
    return Row(
      children: [
        Text(
          'My Courses',
          style: TextStyle(
            color: AppColor.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
