import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';
import '../course_details.dart';
import '../course_items.dart';

class AllCourses extends StatefulWidget {
  const AllCourses({super.key});

  @override
  State<AllCourses> createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {
  int selectedCategoryIndex = 0;

  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  Future<List<Course>> fetchAllCourses() async {
    List<Course> allCourses = [];

    // Get the courses collection
    QuerySnapshot courseSnapshot =
        await FirebaseFirestore.instance.collection('courses').get();

    // Fetch each course
    for (var doc in courseSnapshot.docs) {
      Course course = Course.fromMap(doc.data() as Map<String, dynamic>);
      allCourses.add(course);
    }

    return allCourses;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffbfe0f8),
        appBar: AppBar(
          title: const Text(
            "All Courses",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: FutureBuilder<List<Course>>(
          future: fetchAllCourses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No courses available'));
            } else {
              List<Course> allCourses = snapshot.data!;
              return CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 15, right: 15),
                          child: CourseItem(
                            data: allCourses[index],
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetails(course: allCourses[index]),
                              ));
                            },
                          ),
                        );
                      },
                      childCount: allCourses.length,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
