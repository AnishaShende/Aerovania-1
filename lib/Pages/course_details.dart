import 'package:aerovania_app_1/components/bookmark_box.dart';
import 'package:aerovania_app_1/components/lesson_items.dart';
import 'package:aerovania_app_1/components/color.dart';
import 'package:aerovania_app_1/components/my_button.dart';
import 'package:aerovania_app_1/utils/data.dart';
import 'package:aerovania_app_1/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails({super.key, required this.data});
  final data;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late var courseData;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    courseData = widget.data["course"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      bottomNavigationBar: getFooter(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        "Details",
        style: TextStyle(color: AppColor.textColor),
      ),
      iconTheme: const IconThemeData(color: AppColor.textColor),
      actions: const [],
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: courseData["id"].toString() + courseData["image"],
            child: CustomImage(
              courseData["image"],
              radius: 10,
              width: double.infinity,
              height: 220,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // SingleChildScrollView(
          //   child: Column(
          //     children: [
          getInfo(),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          getTabBar(),
          getTabbarPages(),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget getLessons() {
    return ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return LessonItems(
            data: lessons[index],
          );
        });
  }

  Widget getTabBar() {
    return TabBar(
      indicatorColor: AppColor.primary,
      controller: tabController,
      tabs: const [
        Tab(
          child: Text(
            "Lessons",
            style: TextStyle(fontSize: 14, color: AppColor.textColor),
          ),
        ),
        Tab(
          child: Text(
            "Exercises",
            style: TextStyle(fontSize: 14, color: AppColor.textColor),
          ),
        ),
      ],
    );
  }

  Widget getTabbarPages() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          getLessons(),
          const Text("Exercises"),
        ],
      ),
    );
  }

  Widget getInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              courseData["name"] ?? 'coursename',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textColor),
            ),
            BookmarkBox(
              isBookmarked: courseData["is_favorited"],
              onTap: () {
                setState(() {
                  courseData["is_favorited"] = !courseData["is_favorited"];
                });
              },
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getAttribute(Icons.play_circle_outline,
                courseData["session"] ?? '12 lessons', AppColor.labelColor),
            const SizedBox(
              width: 20,
            ),
            getAttribute(Icons.schedule_outlined,
                courseData["duration"] ?? '10 hours', AppColor.labelColor),
            const SizedBox(
              width: 20,
            ),
            getAttribute(
                Icons.star, courseData["review"] ?? '5', AppColor.yellow),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About Course",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textColor),
            ),
            SizedBox(
              height: 10,
            ),
            ReadMoreText(
              courseData["description"] ?? 'Description of the course',
              // "sds",
              trimLines: 2,
              trimMode: TrimMode.Line,
              style: TextStyle(fontSize: 14, color: AppColor.labelColor),
              // trimCollapsedText: "show more",
              moreStyle: TextStyle(
                  fontSize: 14,
                  color: AppColor.primary,
                  fontWeight: FontWeight.w500),
            ),
            //     Text(
            //   "detail...",
            //   style: TextStyle(
            //       fontSize: 14,
            //       color: AppColor.labelColor),
            // ),
          ],
        ),
      ],
    );
  }

  Widget getAttribute(IconData icon, String info, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          info,
          style: const TextStyle(color: AppColor.labelColor),
        ),
      ],
    );
  }

  Widget getFooter() {
    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(.05),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                "price",
                style: TextStyle(
                    fontSize: 13,
                    color: AppColor.labelColor,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                courseData["price"],
                style: const TextStyle(
                    fontSize: 18,
                    color: AppColor.textColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: MaterialButton(
              color: Color(0xFF1E232C),
              shape: RoundedRectangleBorder(
                // side: const Border(
                //   color: Color(0xFF1E232C),
                // ),
                borderRadius: BorderRadius.circular(8),
              ),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => HomeScreen(
                //             // onTap: togglePage,
                //             )));
              },
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Buy Now",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
