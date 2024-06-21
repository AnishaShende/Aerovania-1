import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';
import '../course_details.dart';
import '../course_items.dart';

class RecommendedCourses extends StatefulWidget {
  const RecommendedCourses({super.key});

  @override
  State<RecommendedCourses> createState() => _RecommendedCoursesState();
}

class _RecommendedCoursesState extends State<RecommendedCourses> {
  int selectedCategoryIndex = 0;

  late ScrollController scrollController;

  @override
  void initState() {
    // Initialize the ScrollController
    scrollController = ScrollController();
    super.initState();
  }

  Future<List<Course>> fetchRecommendedCourses() async {
    List<Course> recommendedCourses = [];

    // Get the recommends collection
    QuerySnapshot recommendSnapshot =
        await FirebaseFirestore.instance.collection('recommends').get();

    // Fetch each recommended course
    for (var doc in recommendSnapshot.docs) {
      String courseId = doc['CourseId'];
      DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get();
      Course course =
          Course.fromMap(courseSnapshot.data() as Map<String, dynamic>);
      recommendedCourses.add(course);
    }

    return recommendedCourses;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xffbfe0f8),
      appBar: AppBar(
        title: const Text(
          "Recommended Courses",
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
        future: fetchRecommendedCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recommended courses available'));
          } else {
            List<Course> recommendedCourses = snapshot.data!;
            return CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 15, right: 15),
                        child: CourseItem(
                          data: recommendedCourses[index],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CourseDetails(
                                  course: recommendedCourses[index], isPurchasedCourse: false),
                            ));
                          },
                        ),
                      );
                    },
                    childCount: recommendedCourses.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    ));
  }
}
