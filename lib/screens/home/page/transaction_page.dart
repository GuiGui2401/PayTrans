import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Of All Transactions')),
      body: const Center(child: Text('List Of All Transactions Page Content')),
    );
  }
}
