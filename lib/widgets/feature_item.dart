import 'package:flutter/material.dart';
import '../components/color.dart';
import 'custom_image.dart';

class FeatureItem extends StatelessWidget {
  FeatureItem({
    Key? key,
    required this.data,
    this.width = 280,
    this.height = 290,
    this.onTap,
  }) : super(key: key);

  final data;
  final double width;
  final double height;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            Hero(
              tag: data["id"].toString() + data["image"],
              child: CustomImage(
                data["image"],
                width: double.infinity,
                height: 190,
                radius: 15,
              ),
            ),
            Positioned(
              top: 170,
              right: 15,
              child: _buildPrice(),
            ),
            Positioned(
              top: 210,
              child: _buildInfo(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      width: width - 20,
      padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              color: AppColor.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildAttributes(),
        ],
      ),
    );
  }

  Widget _buildPrice() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Text(
        data["price"],
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAttributes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        _getAttribute(
          Icons.play_circle_outlined,
          AppColor.labelColor,
          data["session"],
        ),
        _getAttribute(
          Icons.schedule_rounded,
          AppColor.labelColor,
          data["duration"],
        ),
        _getAttribute(
          Icons.star,
          AppColor.yellow,
          data["review"],
        ),
      ],
    );
  }

  _getAttribute(IconData icon, Color color, String info) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            info,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColor.labelColor, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
