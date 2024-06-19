import 'package:aerovania_app_1/components/bookmark_box.dart';
import 'package:aerovania_app_1/components/color.dart';
// import 'package:aerovania_app_1/models/course.dart';
// import 'package:aerovania_app_1/utils/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CourseItem extends StatelessWidget {
  const CourseItem({super.key, required this.data, required this.onTap});

  final data;
  // final GestureTapCallback? onBookmark;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * .8, // 200
        height: MediaQuery.of(context).size.height * .4, // 290
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(.1),
              blurRadius: 1,
              spreadRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width * .9, //double.infinity,
                  height: MediaQuery.of(context).size.height * .28, //200,
                  child: CachedNetworkImage(
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    imageUrl: data.image,
                  ),
                ),
              ],
            ),
            Positioned(
                top: 195, //MediaQuery.of(context).size.height * .65, //175,
                right: 15,
                // Container(
                // alignment: Alignment.topRight,
                child: BookmarkBox(
                  course: data,
                  // onTap: onBookmark,
                  // isBookmarked: data["is_favorited"],
                )),
            //),
            Positioned(
              top: 230,
              // Container(
              // alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                //MediaQuery.of(context).size.width - 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .3, //15,

                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              getAttribute(Icons.sell_outlined, data.price,
                                  AppColor.labelColor),
                              getAttribute(Icons.play_circle_filled_outlined,
                                  data.session, AppColor.labelColor),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              getAttribute(Icons.schedule_outlined,
                                  data.duration, AppColor.labelColor),
                              getAttribute(Icons.star, data.review.toString(),
                                  AppColor.yellow),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getAttribute(IconData icon, String name, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: color,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          name,
          style: const TextStyle(fontSize: 13, color: AppColor.labelColor),
        ),
      ],
    );
  }
}
