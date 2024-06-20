import 'package:aerovania_app_1/components/color.dart';
import 'package:flutter/material.dart';

class LessonItems extends StatelessWidget {
  const LessonItems({super.key, required this.name, required this.thumbnail, required this.duration});
  
  final name;
  final thumbnail;
  final duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(.07),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            thumbnail ?? '',
            
            width: 70,
            height: 70,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'lessonname',
                  style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      color: AppColor.labelColor,
                      size: 14,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      duration ?? '5 min',
                      style:
                          TextStyle(color: AppColor.labelColor, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColor.labelColor,
            size: 15,
          ),
        ],
      ),
    );
  }
}
