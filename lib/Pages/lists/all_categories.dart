import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';
import 'filtered_list.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    List<Map<String, dynamic>> categoriesList = [];

    // Get the categories collection
    QuerySnapshot categorySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    // Fetch each category
    for (var doc in categorySnapshot.docs) {
      categoriesList.add(doc.data() as Map<String, dynamic>);
    }

    return categoriesList;
  }

  Future<List<Course>> fetchCourses() async {
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
            "All Categories",
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
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No categories available'));
            } else {
              List<Map<String, dynamic>> categories = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      minVerticalPadding:
                          MediaQuery.of(context).size.height * .05,
                      leading: Image.asset(
                        category["icon"],
                        height: MediaQuery.of(context).size.height * .1,
                        width: MediaQuery.of(context).size.width * .1,
                      ),
                      title: Text(
                        category["name"],
                        style: const TextStyle(fontSize: 20),
                      ),
                      onTap: () async {
                        List<Course> courses = await fetchCourses();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilteredCoursesScreen(
                              category: category['name'],
                              courses: courses,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
