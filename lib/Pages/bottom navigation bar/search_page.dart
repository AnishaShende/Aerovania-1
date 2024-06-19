import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';
import '../../components/color.dart';
import '../category_items.dart';
import '../course_details.dart';
import '../course_items.dart';

enum SortBy { lowToHigh, highToLow }

final searchQueryProvider = StateProvider<String>((ref) => '');
final bookmarkedFilterProvider = StateProvider<bool>((ref) => false);
final sortByProvider = StateProvider<SortBy>((ref) => SortBy.lowToHigh);

final ratingFilterProvider = StateProvider<bool>((ref) => false);
final durationFilterProvider = StateProvider<bool>((ref) => false);
final lessonsFilterProvider = StateProvider<bool>((ref) => false);
final priceFilterProvider = StateProvider<bool>((ref) => false);

class SearchScreen extends ConsumerWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final _key = GlobalKey<ScaffoldState>();

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
              ),
              SliverToBoxAdapter(
                child: getSearchBox(context, ref),
              ),
              SliverToBoxAdapter(
                child: getCategories(context),
              ),
              searchFunc(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAppBar() {
    return const Row(
      children: [
        Text(
          'Explore',
          style: TextStyle(
            color: AppColor.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget getSearchBox(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * .05,
              width: MediaQuery.of(context).size.width * .65,
              padding: const EdgeInsets.only(
                bottom: 3,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadowColor.withOpacity(.05),
                    spreadRadius: .5,
                    blurRadius: .5,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value.trim();
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              showFilterDialog(context, ref);
            },
            child: Container(
              height: MediaQuery.of(context).size.height * .05,
              width: MediaQuery.of(context).size.width * .1,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.settings_input_component_outlined,
                color: Colors.black54,
              ),
            ),
          )
        ],
      ),
    );
  }

  void showFilterDialog(BuildContext context, WidgetRef ref) {
    String selectedFilter = 'Rating';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Filter and Sort'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filter by:'),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      value: selectedFilter,
                      isExpanded: true,
                      items: <String>['Rating', 'Duration', 'Lessons', 'Price']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFilter = newValue!;
                        });
                      },
                    ),
                    Divider(height: 20, thickness: 1),
                    Text('Sort by:'),
                    SizedBox(height: 10),
                    RadioListTile<SortBy>(
                      title: Text('Low to High'),
                      value: SortBy.lowToHigh,
                      groupValue: ref.watch(sortByProvider),
                      onChanged: (SortBy? value) {
                        if (value != null) {
                          ref.read(sortByProvider.notifier).state = value;
                        }
                      },
                    ),
                    RadioListTile<SortBy>(
                      title: Text('High to Low'),
                      value: SortBy.highToLow,
                      groupValue: ref.watch(sortByProvider),
                      onChanged: (SortBy? value) {
                        if (value != null) {
                          ref.read(sortByProvider.notifier).state = value;
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(ratingFilterProvider.notifier).state =
                        selectedFilter == 'Rating';
                    ref.read(durationFilterProvider.notifier).state =
                        selectedFilter == 'Duration';
                    ref.read(lessonsFilterProvider.notifier).state =
                        selectedFilter == 'Lessons';
                    ref.read(priceFilterProvider.notifier).state =
                        selectedFilter == 'Price';

                    Navigator.pop(context);
                  },
                  child: Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

Widget getCategories(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * .1,
    width: MediaQuery.of(context).size.width * 1,
    child: SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 15),
      scrollDirection: Axis.horizontal,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return Text('Error fetching categories');
          }

          // Convert snapshot data into a list of categories
          List<DocumentSnapshot> categories = snapshot.data!.docs;

          return Row(
            children: List.generate(
              categories.length,
              (index) {
                final category =
                    categories[index].data() as Map<String, dynamic>;
                return CategoryItems(
                  onTap: () {},
                  data: category,
                );
              },
            ).toList(),
          );
        },
      ),
    ),
    // },
  );
  //   ),
  // );
}

Widget searchFunc(BuildContext context, WidgetRef ref) {
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance.collection('courses').get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (!snapshot.hasData || snapshot.hasError) {
        return SliverToBoxAdapter(
          child: Center(child: Text('Error fetching courses')),
        );
      }

      List courses = snapshot.data!.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
      List filteredCourses = courses.where((course) {
        final title = Course.fromMap(course).name.toLowerCase();
        return title.contains(searchQuery);
      }).toList();

      final sortBy = ref.watch(sortByProvider);

      if (ref.watch(ratingFilterProvider)) {
        filteredCourses.sort((a, b) => compareCourseReview(a, b, sortBy));
      } else if (ref.watch(durationFilterProvider)) {
        filteredCourses.sort((a, b) => compareCourseDuration(a, b, sortBy));
      } else if (ref.watch(lessonsFilterProvider)) {
        filteredCourses.sort((a, b) => compareCourseSession(a, b, sortBy));
      } else if (ref.watch(priceFilterProvider)) {
        filteredCourses.sort((a, b) => compareCoursePrice(a, b, sortBy));
      }

      if (filteredCourses.isEmpty) {
        return SliverToBoxAdapter(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Center(
              child: Text(
                'No Results Found',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        );
      } else {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: CourseItem(
                  data: Course.fromMap(filteredCourses[index]),
                  onTap: () {
                    Course courseD = Course.fromMap(filteredCourses[index]);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CourseDetails(course: courseD),
                    ));
                  },
                ),
              );
            },
            childCount: filteredCourses.length,
          ),
        );
      }
    },
  );
}

int compareCoursePrice(
    Map<String, dynamic> a, Map<String, dynamic> b, SortBy sortBy) {
  final courseA = Course.fromMap(a);
  final courseB = Course.fromMap(b);

  return double.parse(courseA.price.substring(2))
      .compareTo(double.parse(courseB.price.substring(2)));
}

int compareCourseReview(
    Map<String, dynamic> a, Map<String, dynamic> b, SortBy sortBy) {
  final courseA = Course.fromMap(a);
  final courseB = Course.fromMap(b);

  return double.parse(courseB.review).compareTo(double.parse(courseA.review));
}

int compareCourseDuration(
    Map<String, dynamic> a, Map<String, dynamic> b, SortBy sortBy) {
  final courseA = Course.fromMap(a);
  final courseB = Course.fromMap(b);

  return int.parse(courseA.duration.split(' ')[0])
      .compareTo(int.parse(courseB.duration.split(' ')[0]));
}

int compareCourseSession(
    Map<String, dynamic> a, Map<String, dynamic> b, SortBy sortBy) {
  final courseA = Course.fromMap(a);
  final courseB = Course.fromMap(b);

  return int.parse(courseA.session.split(' ')[0])
      .compareTo(int.parse(courseB.session.split(' ')[0]));
}
