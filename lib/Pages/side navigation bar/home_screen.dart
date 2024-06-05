// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:aerovania_app_1/Pages/course_details.dart';
import 'package:aerovania_app_1/Pages/home_page.dart';
import 'package:aerovania_app_1/components/color.dart';
import 'package:aerovania_app_1/utils/data.dart';
import 'package:aerovania_app_1/widgets/category_box.dart';
import 'package:aerovania_app_1/widgets/feature_item.dart';
import 'package:aerovania_app_1/widgets/notification_box.dart';
import 'package:aerovania_app_1/widgets/recommend_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

// import 'chat_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  var username = '';

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: retrieveName(), // the Future your FutureBuilder will work with
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // show an error message if something went wrong
        } else {
          return Scaffold(
            drawer: SafeArea(child: ExampleSidebarX(controller: _controller)),

            // body: _buildUserList(),
            backgroundColor: const Color(0xffbfe0f8),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    onPressed: () {
                      // ExampleSidebarX(controller: _controller);
                      // _controller.setExtended(true);
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => _pages[_controller.selectedIndex]),
                      //   );
                      //   _pages[_controller.selectedIndex];
                      //   if (!Platform.isAndroid && !Platform.isIOS) {
                      //     _controller.setExtended(true);
                      //   }
                      //   _key.currentState?.openDrawer();
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu, color: Colors.black),
                  ),
                  backgroundColor: AppColor.appBarColor,
                  pinned: true,
                  snap: true,
                  floating: true,
                  title: _buildAppBar(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildBody(),
                    childCount: 1,
                  ),
                ),
                //   SliverToBoxAdapter(
                //     child: _bottomnavpages[selectedIndex],
                // ),
                // _bottomnavpages[selectedIndex],
              ],
            ),
          );
        }
      },
    );
  }

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    }
    if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  Future<String> retrieveName() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    var document = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    username = document.data()?['username'] ?? '';
    return username;
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  color: AppColor.labelColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                getGreeting(),
                style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        NotificationBox(
          notifiedNumber: 1,
        )
      ],
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategories(),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              "Featured",
              style: TextStyle(
                color: AppColor.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
          _buildFeatured(),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textColor),
                ),
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: AppColor.darker),
                ),
              ],
            ),
          ),
          _buildRecommended(),
          // _bottomnavpages[selectedIndex],
        ],
      ),
    );
  }

  _buildCategories() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categories.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CategoryBox(
              selectedColor: Colors.white,
              data: categories[index],
              onTap: null,
            ),
          ),
        ),
      ),
    );
  }

  _buildFeatured() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 290,
        enlargeCenterPage: true,
        disableCenter: true,
        viewportFraction: .75,
      ),
      items: List.generate(
        features.length,
        (index) => FeatureItem(
          // key: ValueKey(features[index].id), // Added
          data: features[index],
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => CourseDetails(
                      data: {"course": features[index]},
                    ))));
          },
        ),
      ),
    );
  }

  _buildRecommended() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          recommends.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: RecommendItem(
              // key: ValueKey(recommends[index].id), // Added
              data: recommends[index],
            ),
          ),
        ),
      ),
    );
  }
}


  // Widget _buildUserList() {
    // return StreamBuilder<QuerySnapshot>(
    //   stream: FirebaseFirestore.instance.collection('users').snapshots(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) {
    //       return const Text('Error!');
    //     }
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Text('Loading...');
    //     }

    //     return ListView(
    //       children: snapshot.data!.docs
    //           .map<Widget>((doc) => _buildUserListItem(doc))
    //           .toList(),
    //     );
    //   },
    // );
  // }

  // _buildUserListItem(DocumentSnapshot document) {
    // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // if (_auth.currentUser!.email != data['email']) {
    //   return ListTile(
    //     title: Text(data['email']),
    //     onTap: () {
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => ChatPage(
    //               receiverUserEmail: data['email'],
    //               receiverUserName: data['name'],
    //               receiverUserID: data['uid'],
    //             ),
    //           ));
    //     },
    //   );
    // } else {
    //   return Container();
    // }
  // }
// }