import 'package:aerovania_app_1/Pages/course_details.dart';
import 'package:aerovania_app_1/Pages/course_items.dart';
import 'package:aerovania_app_1/utils/data.dart';
import 'package:flutter/material.dart';

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
        // backgroundColor: const Color(0xffbfe0f8),
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
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                  child: CourseItem(
                    data: courses[index],
                    onBookmark: () {
                      courses[index]["is_favorited"] =
                          !courses[index]["is_favorited"];
                    },
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => CourseDetails(
                                data: {"course": courses[index]},
                              ))));
                    },
                  ),
                );
              },
              childCount: courses.length,
            ),
          ),
        ],
      ),
    ));
  }
}
