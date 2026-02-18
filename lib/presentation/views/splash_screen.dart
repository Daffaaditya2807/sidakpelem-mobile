import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidak_desa_mobile/core/const/app_colors.dart';
import 'package:sidak_desa_mobile/presentation/controllers/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final controller = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(width: 200, 'assets/images/logo.png'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }
}
