import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../components/bookmark_box.dart';
import '../components/color.dart';
import '../components/lesson_items.dart';
import '../models/course.dart';
import '../services/helper/firebase_services.dart';
import '../services/pdf/pdf_screen.dart';
import '../services/video/video_player.dart';
import '../widgets/custom_image.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails({super.key, required this.course});
  final Course course;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Course courseData;
  bool isPurchased = false;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  // final String courseId = Course.id;
  final CollectionReference assignmentsCollection = FirebaseFirestore.instance
      .collection('course_1')
      .doc('course_documents')
      .collection('assignments');

  Future<List<Map<String, dynamic>>> fetchAssignments() async {
    QuerySnapshot querySnapshot = await assignmentsCollection.get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    courseData = widget.course;
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
            tag: courseData.id.toString() + courseData.image,
            child: CustomImage(
              courseData.image,
              fit: BoxFit.cover,
              radius: 10,
              width: double.infinity,
              height: 220,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          getInfo(),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          getTabBar(),
          getTabbarPages(),
        ],
      ),
    );
  }

  Widget getLessons() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('course_1')
            .doc('course_documents')
            .collection('videos')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var videos = snapshot.data!.docs;

          // Sort the videos by name
          videos.sort((a, b) {
            var aName = a['name'].split('.')[0];
            var bName = b['name'].split('.')[0];
            return aName.compareTo(bName);
          });

          String getVideoName(String name) {
            if (!name.contains('.')) return name.toUpperCase();
            name = name.replaceAll(RegExp(r'\.mp4$'), '');
            return name.split('.')[1].toUpperCase();
          }

          return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                var video = videos[index];
                var videoUrl = video['url'];
                var videoName = video['name'];
                if (!isPurchased) {
                  return ListTile(
                    leading: Icon(Icons.lock, color: Colors.grey),
                    title: Text(getVideoName(videoName)),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerModel(
                          videoUrl: videoUrl,
                          name: getVideoName(videoName),
                        ),
                      ),
                    );
                  },
                  child: LessonItems(
                    name: getVideoName(videoName),
                    thumbnail: 'assets/images/applogo.png',
                    duration: '55 min',
                  ),
                );
              });
        });
  }

  Widget showAssignments() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchAssignments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No assignments found.'));
        } else {
          var assignments = snapshot.data!;

          assignments.sort((a, b) {
            var aName = a['name'].split('.')[0].toUpperCase();
            var bName = b['name'].split('.')[0].toUpperCase();
            aName = aName.split(' ').last;
            bName = bName.split(' ').last;
            return aName.compareTo(bName);
          });

          return getAssignments(assignments);
        }
      },
    );
  }

  Widget getAssignments(List<Map<String, dynamic>> assignments) {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final assignment = assignments[index];

        String getAssignmentName(String name) {
          if (!name.contains('.')) return name.toUpperCase();
          name = name.replaceAll(RegExp(r'\.pdf$'), '');
          return name.split('.')[0].toUpperCase();
        }

        if (!isPurchased) {
          return ListTile(
            leading: Icon(Icons.lock, color: Colors.grey),
            title: Text(getAssignmentName(assignment['name'])),
          );
        }

        return ListTile(
          title: Text(getAssignmentName(assignment['name'])),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfScreen(pdfPath: assignment['name']),
              ),
            );
          },
        );
      },
    );
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
            "Assignments",
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
          showAssignments(),
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
              courseData.name,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textColor),
            ),
            BookmarkBox(course: courseData),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getAttribute(Icons.play_circle_outline, courseData.session,
                AppColor.labelColor),
            const SizedBox(width: 20),
            getAttribute(Icons.schedule_outlined, courseData.duration,
                AppColor.labelColor),
            const SizedBox(width: 20),
            getAttribute(
                Icons.star, courseData.review.toString(), AppColor.yellow),
            const SizedBox(height: 20),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About Course",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textColor),
            ),
            const SizedBox(height: 10),
            ReadMoreText(
              courseData.description,
              trimLines: 2,
              trimMode: TrimMode.Line,
              style: const TextStyle(fontSize: 14, color: AppColor.labelColor),
              moreStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColor.primary,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget getAttribute(IconData icon, String info, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 5),
        Text(info, style: const TextStyle(color: AppColor.labelColor)),
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
                "Price",
                style: TextStyle(
                    fontSize: 13,
                    color: AppColor.labelColor,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 3),
              Text(
                courseData.price,
                style: const TextStyle(
                    fontSize: 18,
                    color: AppColor.textColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(width: 30),
          Expanded(
            child: MaterialButton(
              color: const Color(0xFF1E232C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onPressed: () async {
                setState(() {
                  isPurchased = true;
                });
                await FirebaseService()
                    .uploadPurchasedCourses(userId, [courseData.id.toString()]);
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
