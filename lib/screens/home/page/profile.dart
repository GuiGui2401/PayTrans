import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isEditing = false;

  // Charger les données de l'utilisateur connecté
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Requête pour obtenir les données de l'utilisateur via l'UID
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
        });
      }
    }
  }

  // Mettre à jour les informations utilisateur
  Future<void> _updateUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Mettre à jour les données dans Firestore
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String docId = userSnapshot.docs.first.id;

        await _firestore.collection('users').doc(docId).update({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        });

        setState(() {
          _isEditing = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page',
            style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _updateUserData();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildTextField('Name', _nameController, enabled: _isEditing),
            const SizedBox(height: 10),
            _buildTextField('Email', _emailController, enabled: _isEditing),
            const SizedBox(height: 10),
            _buildTextField('Phone', _phoneController, enabled: _isEditing),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool enabled = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        enabled: enabled,
      ),
    );
  }
}
