import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cinetpay/cinetpay.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanQRCodePage extends StatefulWidget {
  const ScanQRCodePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScanQRCodePageState createState() => _ScanQRCodePageState();
}

class _ScanQRCodePageState extends State<ScanQRCodePage> {
  String? scannedData;

  Future<void> _scanQRCode() async {
    String data = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.QR,
    );

    if (data != '-1') {
      setState(() {
        scannedData = data;
      });
      _processPayment(data);
    }
  }

  Future<void> _processPayment(String data) async {
    List<String> paymentInfo = data.split('_');
    String phoneNumber = paymentInfo[0];
    String amount = paymentInfo[1];
    final String transactionId = Random().nextInt(100000000).toString();

    await Get.to(
      CinetPayCheckout(
        title: 'Payment Checkout',
        titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        titleBackgroundColor: Colors.green,
        configData: <String, dynamic>{
          'apikey': '5337111116358eef42b6448.37599996',
          'site_id': int.parse('301005'),
          'notify_url': 'http://127.0.0.1/',
        },
        paymentData: <String, dynamic>{
          'transaction_id': transactionId,
          'amount': double.parse(amount),
          'currency': 'XOF',
          'channels': 'ALL',
          'description': 'Payment for $phoneNumber',
        },
        waitResponse: (data) async {
          if (mounted) {
            setState(() {
              if (kDebugMode) {
                print(data);
              }
            });

            if (data['status'] == 'ACCEPTED') {
              await _updateUserSolde(phoneNumber, double.parse(amount));
              await _recordTransaction(
                  phoneNumber, double.parse(amount), 'ACCEPTED');
            }

            final icon = data['status'] == 'ACCEPTED'
                ? Icons.check_circle
                : Icons.mood_bad_rounded;
            final color =
                data['status'] == 'ACCEPTED' ? Colors.green : Colors.redAccent;

            Get.back();
            _showPaymentResult(icon, color, data['status']);
          }
        },
        onError: (data) {
          if (mounted) {
            setState(() {
              if (kDebugMode) {
                print(data);
              }
              _showPaymentResult(Icons.warning_rounded, Colors.yellowAccent,
                  data['description']);
              Get.back();
            });
          }
        },
      ),
    );
  }

// Fonction pour enregistrer les transactions dans Firestore
  Future<void> _recordTransaction(
      String phoneNumber, double amount, String status) async {
    try {
      await FirebaseFirestore.instance.collection('transactions').add({
        'phoneNumber': phoneNumber,
        'amount': amount,
        'status': status,
        'date': Timestamp.now(), // Date de la transaction
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'enregistrement de la transaction : $e');
      }
    }
  }

  Future<void> _updateUserSolde(String phoneNumber, double amount) async {
    try {
      // Récupérer le document utilisateur à partir de son numéro de téléphone
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(phoneNumber)
          .get();

      if (userDoc.exists) {
        // Récupérer le solde actuel
        double currentSolde = userDoc['solde'] ?? 0.0;

        // Ajouter le montant transféré au solde actuel
        double updatedSolde = currentSolde + amount;

        // Mettre à jour le solde dans Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(phoneNumber)
            .update({'solde': updatedSolde});
      } else {
        if (kDebugMode) {
          print('Utilisateur non trouvé');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour du solde : $e');
      }
    }
  }

  void _showPaymentResult(IconData icon, Color color, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(icon, color: color, size: 50),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A6FB0),
            ),
            child: const Text('OK',
                style: TextStyle(
                    color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scanner un Code QR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _scanQRCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A6FB0),
          ),
          child: const Text('Scanner QR Code',
              style: TextStyle(
                  color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
