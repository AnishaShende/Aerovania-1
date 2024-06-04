import 'package:aerovania_app_1/components/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookmarkBox extends StatelessWidget {
  BookmarkBox({super.key, this.onTap, this.isBookmarked = false});
  final GestureTapCallback? onTap;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isBookmarked ? AppColor.primary : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(.05),
              spreadRadius: .5,
              blurRadius: .5,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: SvgPicture.asset(
          "assets/icons/bookmark.svg",
          theme: SvgTheme(
              currentColor: isBookmarked ? Colors.white : AppColor.primary),
          // color: isBookmarked ? Colors.white : AppColor.primary,
          width: 25,
          height: 25,
        ),
      ),
    );
  }
}
