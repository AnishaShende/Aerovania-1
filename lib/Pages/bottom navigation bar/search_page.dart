import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../../models/course.dart';
import '../../components/color.dart';
import '../../widgets/category_box.dart';
import '../course_details.dart';
import '../course_items.dart';
import '../lists/all_categories.dart';
import '../lists/filtered_list.dart';
import '../../data/courses_data.dart' as Courses;

enum SortBy { lowToHigh, highToLow }

final searchQueryProvider = StateProvider<String>((ref) => '');
final debouncedSearchQueryProvider =
    StateNotifierProvider<DebouncedSearchNotifier, String>((ref) {
  return DebouncedSearchNotifier();
});

final bookmarkedFilterProvider = StateProvider<bool>((ref) => false);
final sortByProvider = StateProvider<SortBy>((ref) => SortBy.lowToHigh);

final ratingFilterProvider = StateProvider<bool>((ref) => false);
final durationFilterProvider = StateProvider<bool>((ref) => false);
final lessonsFilterProvider = StateProvider<bool>((ref) => false);
final priceFilterProvider = StateProvider<bool>((ref) => false);

final categoriesProvider =
    StreamProvider.autoDispose<List<DocumentSnapshot>>((ref) {
  return FirebaseFirestore.instance
      .collection('categories')
      .snapshots()
      .map((snapshot) => snapshot.docs);
});

class DebouncedSearchNotifier extends StateNotifier<String> {
  Timer? _debounce;

  DebouncedSearchNotifier() : super('');

  void updateQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      state = query;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xffbfe0f8),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            controller: _scrollController,
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
                child: getSearchBox(context, ref),
              ),
              SliverToBoxAdapter(
                child: getCategories(context, ref),
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
              padding: const EdgeInsets.only(bottom: 3),
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
                textCapitalization: TextCapitalization.words,
                focusNode: _focusNode,
                onChanged: (value) {
                  ref
                      .read(debouncedSearchQueryProvider.notifier)
                      .updateQuery(value.trim());
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
          const SizedBox(width: 10),
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
          ),
        ],
      ),
    );
  }

  void showFilterDialog(BuildContext context, WidgetRef ref) {
    String selectedFilter = 'Rating'; // Default filter selection

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

  Widget getCategories(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return categoriesAsyncValue.when(
      data: (categories) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: MediaQuery.of(context).size.height * .15,
            width: MediaQuery.of(context).size.width * 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
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
            ),
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error fetching categories')),
    );
  }

  Widget searchFunc(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(debouncedSearchQueryProvider).toLowerCase();
    final sortBy = ref.watch(sortByProvider);

    List<Course> filteredCourses = Courses.courses.where((course) {
      return course.name.toLowerCase().contains(searchQuery);
    }).toList();

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
                  fontSize: 20),
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
                data: filteredCourses[index],
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CourseDetails(
                      course: filteredCourses[index],
                      isPurchasedCourse: false,
                    ),
                  ));
                },
              ),
            );
          },
          childCount: filteredCourses.length,
        ),
      );
    }
  }

  int compareCoursePrice(Course a, Course b, SortBy sortBy) {
    final comparison = double.parse(a.price.substring(2))
        .compareTo(double.parse(b.price.substring(2)));
    return sortBy == SortBy.lowToHigh ? comparison : -comparison;
  }

  int compareCourseReview(Course a, Course b, SortBy sortBy) {
    final comparison = double.parse(b.review).compareTo(double.parse(a.review));
    return sortBy == SortBy.lowToHigh ? comparison : -comparison;
  }

  int compareCourseDuration(Course a, Course b, SortBy sortBy) {
    final comparison = int.parse(a.duration.split(' ')[0])
        .compareTo(int.parse(b.duration.split(' ')[0]));
    return sortBy == SortBy.lowToHigh ? comparison : -comparison;
  }

  int compareCourseSession(Course a, Course b, SortBy sortBy) {
    final comparison = int.parse(a.session.split(' ')[0])
        .compareTo(int.parse(b.session.split(' ')[0]));
    return sortBy == SortBy.lowToHigh ? comparison : -comparison;
  }
}
