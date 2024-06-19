import 'package:aerovania_app_1/Pages/bottom%20navigation%20bar/product_list.dart';
import 'package:aerovania_app_1/Pages/side%20navigation%20bar/product_screen.dart';
import 'package:aerovania_app_1/Pages/side%20navigation%20bar/settings_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'bottom navigation bar/my_courses.dart';
import 'bottom navigation bar/favorite_page.dart';
import 'side navigation bar/about_screen.dart';
import 'side navigation bar/contact_screen.dart';
import 'side navigation bar/course_screen.dart';
import 'side navigation bar/history_screen.dart';
import 'side navigation bar/home_screen.dart';
import 'side navigation bar/media_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

FirebaseAuth auth = FirebaseAuth.instance;
var uid = auth.currentUser!.uid;
final List<Widget> _bottomnavpages = [
  const HomeScreen(),
  ProductList(),
  MyCourses(userId: uid),
  const FavoriteScreen()
];

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: ExampleSidebarX(controller: _controller),
      backgroundColor: const Color(0xffbfe0f8), //AppColor.appBgColor,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: selectedIndex,
        items: const <Widget>[
          Icon(Icons.home_filled, size: 30),
          Icon(Icons.shopping_cart, size: 30),
          Icon(Icons.video_collection_rounded, size: 30),
          Icon(Icons.favorite, size: 30),
        ],
        onTap: (int index) {
          selectedIndex = index;
          setState(() {
            selectedIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Row(
        children: [
          Expanded(
            child: _bottomnavpages[selectedIndex],
          ),
        ],
      ),
    );
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SidebarX(
        controller: _controller,
        theme: SidebarXTheme(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: canvasColor,
            // color: white,
            borderRadius: BorderRadius.circular(20),
          ),
          hoverColor: scaffoldBackgroundColor,
          textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
          selectedTextStyle: const TextStyle(color: Colors.black),
          itemTextPadding: const EdgeInsets.only(left: 30),
          selectedItemTextPadding: const EdgeInsets.only(left: 30),
          itemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: canvasColor),
          ),
          selectedItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: actionColor.withOpacity(0.37),
            ),
            gradient: const LinearGradient(
              colors: [canvasColor, canvasColor],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 30,
              )
            ],
          ),
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.7),
            size: 20,
          ),
          selectedIconTheme: const IconThemeData(
            color: Colors.black,
            size: 20,
          ),
        ),
        extendedTheme: const SidebarXTheme(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white, //canvasColor,
          ),
        ),
        footerDivider: divider,
        headerBuilder: (context, extended) {
          return SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('assets/images/applogo.png'),
            ),
          );
        },
        items: [
          SidebarXItem(
            icon: Icons.book,
            label: 'Courses',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CourseScreen()),
              );
              // const CourseScreen();
            },
          ),
          SidebarXItem(
            icon: Icons.airplanemode_active,
            label: 'Products',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductScreen()),
              );
              // const ProductScreen();
            },
          ),
          SidebarXItem(
            icon: Icons.history,
            label: 'History',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
              // const HistoryScreen();
            },
          ),
          SidebarXItem(
            icon: Icons.photo_library,
            label: 'Media',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MediaScreen()),
              );
              // const MediaScreen();
            },
          ),
          SidebarXItem(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              // const SettingsScreen();
            },
          ),
          SidebarXItem(
            icon: Icons.info_outline,
            label: 'About',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
              // const AboutScreen();
            },
            // onTap: ,
          ),
          SidebarXItem(
            icon: Icons.perm_phone_msg_sharp,
            label: 'Contact Us',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactScreen()),
              );
              // const ContactScreen();
            },
          ),
          // const SidebarXItem(
          //   iconWidget: FlutterLogo(size: 20),
          //   label: 'Flutter',
          // ),
        ],
      ),
    );
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xffbfe0f8); // Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: Colors.blue.withOpacity(0.3), height: 1);
