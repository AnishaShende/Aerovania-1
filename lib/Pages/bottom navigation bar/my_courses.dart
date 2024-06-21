import 'package:flutter/material.dart';
import 'package:aerovania_app_1/components/color.dart';
import 'package:aerovania_app_1/models/course.dart';
import '../../services/helper/firebase_services.dart';
import '../course_details.dart';
import '../course_items.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  final FirebaseService _firebaseService = FirebaseService();
  late Stream<List<Course>> coursesStream;
  final _key = GlobalKey<ScaffoldState>();
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    coursesStream = _firebaseService.getPurchasedCoursesStream();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        backgroundColor: const Color(0xffbfe0f8),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            controller: scrollController,
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
              SliverToBoxAdapter(
                child: StreamBuilder<List<Course>>(
                  stream: coursesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    List<Course>? courses = snapshot.data;

                    if (courses == null || courses.isEmpty) {
                      return const Center(child: Text('No courses found.'));
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return CourseItem(
                          data: courses[index],
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CourseDetails(
                                    course: courses[index], isPurchasedCourse: true),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAppBar() {
    return const Text(
      'My Courses',
      style: TextStyle(
        color: AppColor.textColor,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
    );
  }
}
