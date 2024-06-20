import 'package:aerovania_app_1/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
 
  @override
  void initState() {
    super.initState();
  }

  final _controller = SidebarXController(selectedIndex: 3, extended: true);
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
            "Media",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
        ),
      ),
    );
  }
}