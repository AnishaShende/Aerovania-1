import 'package:aerovania_app_1/Pages/home_page.dart';
import 'package:aerovania_app_1/components/color.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late ScrollController scrollController;
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    scrollController = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        // body: _buildUserList(),
        backgroundColor: Color(0xffbfe0f8),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor:
                    const Color(0xffbfe0f8), // AppColor.appBarColor,
                pinned: true,
                title: getAppBar(),
                leading: IconButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  Scaffold.of(context).openDrawer();
                },
                  icon: const Icon(Icons.menu, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getAppBar() {
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
}
