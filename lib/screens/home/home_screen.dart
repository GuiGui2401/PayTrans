import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:paytrans/screens/home/page/generate_qr_code.dart';
import 'package:paytrans/screens/home/page/home.dart';
import 'package:paytrans/screens/home/page/profile.dart';
import 'package:paytrans/screens/home/page/scan_qr_code_page.dart';
import 'package:paytrans/screens/home/page/transaction_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const GenerateQRCodePage(),
    const ScanQRCodePage(),
    const TransactionsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          FlashyTabBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              activeColor: const Color(0xFF2A6FB0),
              inactiveColor: const Color.fromARGB(255, 110, 110, 110)),
          FlashyTabBarItem(
              icon: const Icon(Icons.call_received_rounded),
              title: const Text('Receive'),
              activeColor: const Color(0xFF2A6FB0),
              inactiveColor: const Color.fromARGB(255, 110, 110, 110)),
          FlashyTabBarItem(
              icon: const Icon(Icons.send_and_archive_rounded),
              title: const Text('Send'),
              activeColor: const Color(0xFF2A6FB0),
              inactiveColor: const Color.fromARGB(255, 110, 110, 110)),
          FlashyTabBarItem(
              icon: const Icon(Icons.format_list_bulleted_rounded),
              title: const Text('History'),
              activeColor: const Color(0xFF2A6FB0),
              inactiveColor: const Color.fromARGB(255, 110, 110, 110)),
          FlashyTabBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Profile'),
              activeColor: const Color(0xFF2A6FB0),
              inactiveColor: const Color.fromARGB(255, 110, 110, 110)),
        ],
      ),
    );
  }
}
