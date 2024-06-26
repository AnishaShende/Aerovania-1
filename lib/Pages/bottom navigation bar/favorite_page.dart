import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../course_details.dart';
import '../course_items.dart';
import '../../providers/favorite_provider.dart';
import '../../components/color.dart';
import '../../Pages/home_page.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  late ScrollController scrollController;
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
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
              SliverList(
                delegate: showFavorites(),
              ),
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
          'Favorites',
          style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 24),
        ),
      ],
    );
  }

  SliverChildBuilderDelegate showFavorites() {
    final favoriteState = ref.watch(favoriteProvider);

    if (favoriteState.isLoading) {
      return SliverChildBuilderDelegate(
        (context, index) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        childCount: 1,
      );
    }

    if (favoriteState.courses.isEmpty) {
      return SliverChildBuilderDelegate((context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'No Favorites',
              style: TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'You have not added any favorites yet.',
              style: TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              child: const Text('Explore'),
            ),
          ],
        );
      }, childCount: 1);
    } else {
      return SliverChildBuilderDelegate(
        (context, index) {
          final course = favoriteState.courses[index];
          return Padding(
            padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
            child: CourseItem(
              data: course,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CourseDetails(course: course, isPurchasedCourse: false),
                ));
              },
            ),
          );
        },
        childCount: favoriteState.courses.length,
      );
    }
  }
}
