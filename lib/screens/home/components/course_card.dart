import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    this.color = const Color(0xFF2A6FB0),
    this.iconSrc = "assets/icons/ios.svg",
  });

  final String title, iconSrc, description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
      height: 180,
      width: 260,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6, right: 8),
              child: Column(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 36.0,
                      ),
                    ),
                  ),
                 
                ],
              ),
            ),
          ),
          SvgPicture.asset(iconSrc),
        ],
      ),
    );
  }
}
