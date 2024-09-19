import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  String accountValue = "0 XAF"; // Valeur initiale du solde

  @override
  void initState() {
    super.initState();
    _getAccountValue();
  }

  Future<void> _getAccountValue() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Utilisation de l'UID
          .get();
      if (userDoc.exists) {
        double solde = userDoc['solde'] ?? 0.0; // Récupérer le solde
        setState(() {
          accountValue = "$solde XAF"; // Mettre à jour la valeur du solde
          _updateCoursesWithSolde(accountValue);
        });
      }
    }
  }

  // Fonction pour mettre à jour la description du cours avec la valeur du solde
  void _updateCoursesWithSolde(String solde) {
    courses[0] = Course(
      title: "Account Value",
      description: solde,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(courses[index].title),
            subtitle: Text(courses[index].description),
          );
        },
      ),
    );
  }
}

final List<Course> courses = [
  Course(
    title: "Account Value",
    description: "0 XAF", // Initialement, affiche "0 XAF"
  ),
];

final List<Course> recentCourses = [
  Course(
    title: "Generate Qr Code",
    description: "click to generate qr code",
  ),
  Course(
    title: "Scan Qr Code",
    color: const Color(0xFF4A90E2),
    iconSrc: "assets/icons/code.svg",
    description: "click to scan qr code",
  ),
  Course(
    title: "List Of All Transactions",
    description: "click to see resume of all your transactions",
  ),
  Course(
    title: "Profiles",
    description: "click to edit your profile",
    color: const Color(0xFF4A90E2),
    iconSrc: "assets/icons/code.svg",
  ),
];
