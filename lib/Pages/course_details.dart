import 'package:aerovania_app_1/components/bookmark_box.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
// import 'package:aerovania_app_1/components/bookmark_box.dart';
import 'package:aerovania_app_1/components/lesson_items.dart';
import 'package:aerovania_app_1/components/color.dart';
import 'package:aerovania_app_1/services/video/video_player.dart';
import 'package:aerovania_app_1/widgets/custom_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';
// import '../data/dummy_data.dart';

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
        stream: FirebaseFirestore.instance.collection('course_1').snapshots(),
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
            // re786y`6  ee655t  ` ET655TF565E66TY6EUJT  R67YU7UY6JUJT5E466R56           67uj656ty7u6eujt  r67yu7uy6jujt5e466r56
          });
          getVideoName(String name) {
            name.replaceAll(RegExp('mp4'), '');
            return name.split('.')[1].toUpperCase();
          }

          return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                var video = videos[index];
                var videoUrl = video['url'];
                var videoName = video['name'];
                return GestureDetector(
                  onTap: () {
                    print("lesson tapped!");
                    // FileStorageService().fetchAndStoreMetadata('course_1/videos');
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
                    // Image.asset('assets/appicon.png'),
                    // data: lessons[index],
                    name: getVideoName(videoName),
                    thumbnail: 'assets/images/applogo.png',
                    duration: '55 min',
                  ),
                );
              });
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
              courseData.name,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textColor),
            ),
            BookmarkBox(course: courseData),
            //  BookmarkBox was here
            // IconButton(
            //   icon: Icon(
            //     courseData.isFavorited ? Icons.bookmark : Icons.bookmark_border,
            //   ),
            //   onPressed: () {
            //     // setState(() {
            //     //   courseData = Course(
            //     //     id: courseData.id,
            //     //     name: courseData.name,
            //     //     image: courseData.image,
            //     //     price: courseData.price,
            //     //     duration: courseData.duration,
            //     //     session: courseData.session,
            //     //     review: courseData.review,
            //     //     isFavorited: !courseData.isFavorited,
            //     //     description: courseData.description,
            //     //   );
            //     // });
            //   },
            // ),
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
              // trimCollapsedText: "show more",
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
              onPressed: () {
                // Add your buy now logic here
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
