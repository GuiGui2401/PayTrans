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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        phoneNumber = userDoc['phone'];
      });
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
              child: Column(
                children: [
                  TextField(
                    controller: _amountController,
                    decoration:
                        const InputDecoration(labelText: 'Montant à recevoir'),
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
                    child: const Text('Générer QR Code'),
                  ),
                ],
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
