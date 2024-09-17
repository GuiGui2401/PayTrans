import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cinetpay/cinetpay.dart';
import 'package:get/get.dart';

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

    // Naviguer vers la page CinetPayCheckout
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
        waitResponse: (data) {
          if (mounted) {
            setState(() {
              if (kDebugMode) {
                print(data);
              }
              // Gérez la réponse ici (succès ou échec)
              final icon = data['status'] == 'ACCEPTED'
                  ? Icons.check_circle
                  : Icons.mood_bad_rounded;
              final color = data['status'] == 'ACCEPTED'
                  ? Colors.green
                  : Colors.redAccent;
              Get.back();
              _showPaymentResult(icon, color, data['status']);
            });
          }
        },
        onError: (data) {
          if (mounted) {
            setState(() {
              if (kDebugMode) {
                print(data);
              }
              // Gérez l'erreur ici
              _showPaymentResult(Icons.warning_rounded, Colors.yellowAccent,
                  data['description']);
              Get.back();
            });
          }
        },
      ),
    );
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
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner un Code QR'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _scanQRCode,
          child: const Text('Scanner QR Code'),
        ),
      ),
    );
  }
}
