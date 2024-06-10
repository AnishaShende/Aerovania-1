import 'package:aerovania_app_1/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  
  @override
  void initState() {
    super.initState();
  }

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        drawer: ExampleSidebarX(controller: _controller),
        backgroundColor: const Color(0xffbfe0f8),
        appBar: AppBar(
          title: const Text(
            "Courses",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // backgroundColor: const Color(0xffbfe0f8),
          elevation: 1,
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          //   icon: const Icon(
          //     Icons.arrow_back,
          //     color: Colors.black,
          //   ),
          // ),
        ),
      ),
    );
  }
}
