import 'package:aerovania_app_1/Pages/bottom%20navigation%20bar/search_page.dart';
import 'package:aerovania_app_1/Pages/course_details.dart';
import 'package:aerovania_app_1/Pages/lists/all_categories.dart';
import 'package:aerovania_app_1/Pages/lists/recommended_courses.dart';
import 'package:aerovania_app_1/components/color.dart';
import 'package:aerovania_app_1/widgets/category_box.dart';
import 'package:aerovania_app_1/widgets/feature_item.dart';
import 'package:aerovania_app_1/widgets/notification_box.dart';
import 'package:aerovania_app_1/widgets/recommend_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/course.dart';
import '../lists/filtered_list.dart';
import '../lists/notification_list.dart';
import '../../data/courses_data.dart' as Courses;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String username;

  @override
  void initState() {
    super.initState();
    username = '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: retrieveName(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          username = snapshot.data ?? '';
          return Scaffold(
            backgroundColor: const Color(0xffbfe0f8),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu, color: Colors.black),
                  ),
                  backgroundColor: AppColor.appBarColor,
                  pinned: true,
                  snap: true,
                  floating: true,
                  title: _buildAppBar(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildBody(),
                    childCount: 1,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    }
    if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  Future<String> retrieveName() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    var document = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    return document.data()?['username'] ?? '';
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  color: AppColor.labelColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                getGreeting(),
                style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.appBarColor,
              border: Border.all(
                color: Colors.grey.withOpacity(.3),
              ),
            ),
            child: Icon(
              Icons.search,
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsList()),
            );
          },
          child: NotificationBox(
            notifiedNumber: 0,
          ),
        )
      ],
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategories(),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              "Featured",
              style: TextStyle(
                color: AppColor.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
          _buildFeatured(),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textColor,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: ((context) => const RecommendedCourses())),
                  ),
                  child: Text(
                    "See all",
                    style: TextStyle(fontSize: 14, color: AppColor.darker),
                  ),
                ),
              ],
            ),
          ),
          _buildRecommended(),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.hasError) {
          return Text('Error fetching categories');
        }

        List<DocumentSnapshot> categories = snapshot.data!.docs;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categories.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 15),
                child: CategoryBox(
                  selectedColor: Colors.white,
                  data: categories[index].data() as Map<String, dynamic>,
                  onTap: () {
                    if (index == 0) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AllCategories(),
                      ));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilteredCoursesScreen(
                            category: categories[index]['name'],
                            courses: Courses.courses,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatured() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('features').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.hasError) {
          return Text('Error fetching featured items');
        }

        List<DocumentSnapshot> features = snapshot.data!.docs;
        List<String> courseIds = features
            .map((doc) =>
                (doc.data() as Map<String, dynamic>)['CourseId'] as String)
            .toList();

        return FutureBuilder<List<DocumentSnapshot>>(
          future: Future.wait(courseIds.map((courseId) {
            return FirebaseFirestore.instance
                .collection('courses')
                .doc(courseId)
                .get();
          }).toList()),
          builder: (context, courseSnapshot) {
            if (courseSnapshot.hasError) {
              return Text('Error: ${courseSnapshot.error}');
            }

            if (courseSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<DocumentSnapshot> courseDocs = courseSnapshot.data!;
            List<Map<String, dynamic>> courseData = courseDocs
                .where((doc) => doc.exists)
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            return CarouselSlider(
              options: CarouselOptions(
                height: 290,
                enlargeCenterPage: true,
                disableCenter: true,
                viewportFraction: .75,
              ),
              items: List.generate(
                courseData.length,
                (index) => FeatureItem(
                  data: courseData[index],
                  onTap: () async {
                    var course = courseData[index];
                    if (course != null) {
                      Course courseD = Course.fromMap(course);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CourseDetails(course: courseD),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Course not found')),
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecommended() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recommends').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.hasError) {
          return Text('Error fetching recommended items');
        }

        // Assuming 'recommends' collection documents have a field 'CourseId'
        List<String> courseIds = snapshot.data!.docs
            .map((doc) =>
                (doc.data() as Map<String, dynamic>)['CourseId'] as String)
            .toList();

        return FutureBuilder<List<DocumentSnapshot>>(
          future: Future.wait(courseIds.map((courseId) {
            return FirebaseFirestore.instance
                .collection('courses')
                .doc(courseId)
                .get();
          }).toList()),
          builder: (context, courseSnapshot) {
            if (courseSnapshot.hasError) {
              return Text('Error: ${courseSnapshot.error}');
            }

            if (courseSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<DocumentSnapshot> courseDocs = courseSnapshot.data!;
            List<Map<String, dynamic>> courseData = courseDocs
                .where((doc) => doc.exists)
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  courseData.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: RecommendItem(
                      data: courseData[index],
                      onTap: () async {
                        var course = courseData[index];
                        if (course != null) {
                          Course courseD = Course.fromMap(course);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CourseDetails(course: courseD),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Course not found')),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
