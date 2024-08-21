import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SecondaryCourseCard extends StatelessWidget {
  const SecondaryCourseCard({
    super.key,
    required this.title,
    required this.description,
    this.iconsSrc = "assets/icons/ios.svg",
    this.colorl = const Color(0xFF2A6FB0),
    required this.onTap,
  });

  final String title, iconsSrc, description;
  final Color colorl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
            color: colorl,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40,
              child: VerticalDivider(
                color: Colors.white70,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(iconsSrc)
          ],
        ),
      ),
    );
  }
}
