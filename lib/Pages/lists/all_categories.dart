import 'package:aerovania_app_1/Pages/lists/all_courses.dart';
import 'package:aerovania_app_1/Pages/side%20navigation%20bar/home_screen.dart';
import 'package:aerovania_app_1/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
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
            "All Categories",
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
        body: ListView.builder(
          padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
          itemCount: categories.length - 1,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                minTileHeight: MediaQuery.of(context).size.height * .15,
                minLeadingWidth: MediaQuery.of(context).size.width * .15,
                leading: Image(
                  image: AssetImage(categories[index + 1]["icon"]),
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .1,
                  color: selectedCategoryIndex == index
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text(categories[index + 1]["name"],
                    style: const TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllCourses(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
