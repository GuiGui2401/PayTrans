import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:rive_animation/screens/home/home_screen.dart';

class GenerateCodePage extends StatefulWidget {
  const GenerateCodePage({super.key});

  @override
  State<GenerateCodePage> createState() => _GenerateCodePageState();
}

class _GenerateCodePageState extends State<GenerateCodePage> {
  String? qrData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
            },
            icon: const Icon(
              Icons.qr_code_scanner,
            ),
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTextField(),
          if (qrData != null) PrettyQrView.data(data: qrData!),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      onSubmitted: (value) {
        setState(() {
          qrData = value;
        });
      },
    );
  }
}
