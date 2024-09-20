import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String accountValue = "0 XAF"; // Valeur initiale du solde

  @override
  void initState() {
    super.initState();
    _listenToAccountValue(); // Écoute en temps réel des changements du solde
  }

  // Fonction pour écouter les changements du solde en temps réel
  void _listenToAccountValue() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .snapshots() // Écoute des changements en temps réel
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // ignore: unnecessary_cast
          var userData = snapshot.docs.first.data() as Map<String, dynamic>;
          int solde = userData['solde'] ?? 0; // Récupérer le solde
          setState(() {
            accountValue = "$solde XAF"; // Mettre à jour la valeur du solde
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HomePage',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "PayTrans",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: const Color(0xFF2A6FB0),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 110, 110, 110),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "BUSINESS ACCOUNT",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2A6FB0),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_upward,
                                      color: Colors.greenAccent[400],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "12.3%",
                                      style: TextStyle(
                                        color: Color(0xFF2A6FB0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          accountValue,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A6FB0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
