import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GenerateQRCodePage extends StatefulWidget {
  const GenerateQRCodePage({super.key});

  @override
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

  /// Récupère le numéro de téléphone de l'utilisateur à partir de Firestore.
  Future<void> _getUserPhoneNumber() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user
              .uid) // Utiliser l'UID de l'utilisateur au lieu du numéro de téléphone
          .get();

      // Vérifiez que le document existe et contient un numéro de téléphone
      if (userDoc.exists && userDoc['phone'] != null) {
        setState(() {
          phoneNumber = userDoc[
              'phone']; // Utiliser le bon champ pour le numéro de téléphone
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Générer un Code QR'),
      ),
      body: phoneNumber == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    // Champ de texte pour entrer le montant
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                          labelText: 'Montant à recevoir'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    // Bouton pour générer le QR code
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
                        textStyle: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Générer QR Code'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Affiche le QR code dans une boîte de dialogue.
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
