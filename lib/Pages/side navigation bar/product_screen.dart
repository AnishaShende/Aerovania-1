import 'package:aerovania_app_1/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  
  @override
  void initState() {
    super.initState();
  }

  final _controller = SidebarXController(selectedIndex: 1, extended: true);
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
            "Products",
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