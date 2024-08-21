import 'package:flutter/material.dart' show Color;

class Course {
  final String title, description, iconSrc;
  final Color color;

  Course({
    required this.title,
    required this.description,
    this.iconSrc = "assets/icons/ios.svg",
    this.color = const Color(0xFF2A6FB0),
  });
}

final List<Course> courses = [
  Course(
    title: "Account Value",
    description: "0 XAF"
  ),
];

final List<Course> recentCourses = [
  Course(
    title: "Generate Qr Code",
    description: "click to generate qr code"
  ),
  Course(
    title: "Scan Qr Code",
    color: const Color(0xFF4A90E2),
    iconSrc: "assets/icons/code.svg",
    description: "click to scan qr code"
  ),
  Course(
    title: "List Of All Transaction",
    description: "click to see resume of all your transactions"
  ),
  Course(
    title: "Profiles",
    description: "click to edit your profile",
    color: const Color(0xFF4A90E2),
    iconSrc: "assets/icons/code.svg",
  ),
];
