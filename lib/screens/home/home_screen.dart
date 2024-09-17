import 'package:flutter/material.dart';
import 'package:paytrans/screens/home/page/generate_qr_code.dart';
import 'package:paytrans/screens/home/page/scan_qr_code_page.dart';
import 'package:paytrans/screens/home/page/transaction_page.dart';

import '../../model/course.dart';
import 'components/course_card.dart';
import 'components/secondary_course_card.dart';
import 'page/profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "PayTrans",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: courses
                      .map(
                        (course) => Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: CourseCard(
                            title: course.title,
                            description: course.description,
                            iconSrc: course.iconSrc,
                            color: course.color,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "All Actions",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ...recentCourses.map((course) {
                VoidCallback onTap;
                switch (course.title) {
                  case "Generate Qr Code":
                    onTap = () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GenerateQRCodePage()),
                        );
                    break;
                  case "Scan Qr Code":
                    onTap = () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScanQRCodePage()),
                        );
                    break;
                  case "List Of All Transaction":
                    onTap = () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TransactionsPage()),
                        );
                    break;
                  case "Profiles":
                    onTap = () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                    break;
                  default:
                    onTap = () {};
                }

                return Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: SecondaryCourseCard(
                    title: course.title,
                    description: course.description,
                    iconsSrc: course.iconSrc,
                    colorl: course.color,
                    onTap: onTap,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
