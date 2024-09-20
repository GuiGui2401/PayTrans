import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  // Fonction pour récupérer les transactions
  Stream<QuerySnapshot> _getTransactions() {
    return FirebaseFirestore.instance
        .collection('transactions')
        .orderBy('date', descending: true) // Trier par date décroissante
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Of All Transactions',
            style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var transaction =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(
                    'Transaction: ${transaction['amount']} XAF with ${transaction['phoneNumber']}'),
                subtitle: Text('Date: ${transaction['date'].toDate()}'),
              );
            },
          );
        },
      ),
    );
  }
}
