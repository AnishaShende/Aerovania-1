// import 'package:aerovania_app_1/Pages/category_items.dart';
// import 'package:aerovania_app_1/Pages/course_items.dart';
// import 'package:aerovania_app_1/components/color.dart';
// import 'package:aerovania_app_1/utils/data.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class ExploreScreen extends StatefulWidget {
//   const ExploreScreen({super.key});

//   @override
//   State<ExploreScreen> createState() => _ExploreScreenState();
// }

// class _ExploreScreenState extends State<ExploreScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             backgroundColor: AppColor.appBarColor,
//             pinned: true,
//             title: getAppBar(),
//           ),
//           SliverToBoxAdapter(
//             child: getCategories(),
//           ),
//           SliverList(delegate: getCourses())
//         ],
//       ),
//     );
//   }

//   getAppBar() {
//     return const Row(
//       children: [
//         Text(
//           'Explore',
//           style: TextStyle(
//               color: AppColor.textColor,
//               fontWeight: FontWeight.w600,
//               fontSize: 24),
//         ),
//       ],
//     );
//   }

//   getSearchBox() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 15, right: 15),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               height: 40,
//               padding: const EdgeInsets.only(
//                 bottom: 3,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColor.shadowColor.withOpacity(.05),
//                     spreadRadius: .5,
//                     blurRadius: .5,
//                     offset: const Offset(0, 0),
//                   ),
//                 ],
//               ),
//               child: const TextField(
//                 decoration: InputDecoration(
//                   prefixIcon:
//                       ImageIcon(NetworkImage("assets/icons/search.jpg")),
//                   border: InputBorder.none,
//                   hintText: 'Search',
//                   hintStyle: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           Container(
//             padding: const EdgeInsets.all(5),
//             decoration: BoxDecoration(
//               color: AppColor.primary,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Image.asset(
//               "assets/icons/filter.jpg",
//               color: Colors.white,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   int selectedCategoryIndex = 0;
//   getCategories() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.only(left: 15, top: 10, bottom: 15),
//       child: Row(
//         children: List.generate(
//           categories.length,
//           (index) => CategoryItems(
//             onTap: () {
//               setState(() {
//                 selectedCategoryIndex = index;
//               });
//             },
//             isActive: selectedCategoryIndex == index,
//             data: categories[index],
//           ),
//         ),
//       ),
//     );
//   }

//   getCourses() {
//     return SliverChildBuilderDelegate(
//       (context, index) {
//         return Padding(
//           padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
//           child: CourseItem(
//             data: courses[index],
//             onBookmark: () {
//               courses[index]["is_favorited"] = !courses[index]["is_favorited"];
//             },
//           ),
//         );
//       },
//       childCount: courses.length,
//     );
//   }

//   getAttribute(IconData icon, String name, Color color) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 18,
//           color: color,
//         ),
//         const SizedBox(
//           width: 5,
//         ),
//         Text(
//           name,
//           style: const TextStyle(fontSize: 13, color: AppColor.labelColor),
//         ),
//       ],
//     );
//   }
// }
