import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GenerateQRCodePage extends StatefulWidget {
  const GenerateQRCodePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GenerateQRCodePageState createState() => _GenerateQRCodePageState();
}

class _GenerateQRCodePageState extends State<GenerateQRCodePage> {
  final _amountController = TextEditingController();
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    _getUserPhoneNumber();
  }

  Future<void> _getUserPhoneNumber() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Requête pour obtenir les données de l'utilisateur via l'UID
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          phoneNumber = userData['phone'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Générer un Code QR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: phoneNumber == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centrage vertical
                  children: [
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                          labelText: 'Montant à recevoir'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_amountController.text.isNotEmpty) {
                          String qrData =
                              '${phoneNumber}_${_amountController.text}';
                          _showQRCode(qrData);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A6FB0),
                      ),
                      child: const Text('Générer QR Code',
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showQRCode(String data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 200.0,
          height: 200.0,
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: 200.0,
            gapless: false,
          ),
        ),
      ),
    );
  }
}
