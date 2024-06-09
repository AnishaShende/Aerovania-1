import 'package:aerovania_app_1/components/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookmarkBox extends StatefulWidget {
  const BookmarkBox({super.key, this.onTap, this.isBookmarked = false});
  final GestureTapCallback? onTap;
  final bool isBookmarked;

  @override
  State<BookmarkBox> createState() => _BookmarkBoxState();
}

class _BookmarkBoxState extends State<BookmarkBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isBookmarked) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant BookmarkBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBookmarked != oldWidget.isBookmarked) {
      if (widget.isBookmarked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.isBookmarked ? AppColor.primary : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: RotationTransition(
          turns: _rotationAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SvgPicture.asset(
              "assets/icons/bookmark.svg",
              colorFilter: ColorFilter.mode(
                widget.isBookmarked ? Colors.white : AppColor.primary,
                BlendMode.srcIn,
              ),
              width: 25,
              height: 25,
            ),
          ),
        ),
      ),
    );
  }
}
