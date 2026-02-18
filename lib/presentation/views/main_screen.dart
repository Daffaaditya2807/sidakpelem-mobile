import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidak_desa_mobile/core/widgets/app_bottom_navbar.dart';
import 'package:sidak_desa_mobile/presentation/views/pages/dashboard_screen.dart';
import 'package:sidak_desa_mobile/presentation/views/pages/profile_screen.dart';
import 'package:sidak_desa_mobile/presentation/views/pages/scanner_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _pages = const [DashboardScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: AppBottomNavbar(
          currentIndex: _currentIndex,
          onTabSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          onCenterTap: () {
            Get.to(() => const ScannerScreen());
          },
        ),
      ),
    );
  }
}
