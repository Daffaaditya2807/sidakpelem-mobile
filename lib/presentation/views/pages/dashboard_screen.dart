import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidak_desa_mobile/core/const/app_colors.dart';
import 'package:sidak_desa_mobile/presentation/views/login_screen.dart';

import '../../controllers/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 360 ? 18.0 : 21.0;
    final subtitleFontSize = screenWidth < 360 ? 13.0 : 15.0;
    final cardWidth = (screenWidth - 52) / 2;

    final controller = Get.put(DashboardController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            ListTile(
              leading: const CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primaryColor,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
              title: const Text(
                'Selamat Datang!',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
              subtitle: Obx(
                () => Text(
                  'Selamat datang ${controller.user.value?.name ?? 'User'}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  controller.logout().then((_) {
                    Get.off(LoginScreen());
                  });
                },
                icon: const Icon(Icons.logout, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffdff5ec),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sudah Absen Hari Ini?',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Ayo laporkan kehadiranmu sekarang!',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: subtitleFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth * 0.35,
                              ),
                              child: Image.asset(
                                'assets/images/banner.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MenuCard(
                  width: cardWidth,
                  title: 'Izin',
                  backgroundColor: const Color(0xFFF3C644),
                  imagePath: 'assets/images/icon_izin.png',
                ),
                _MenuCard(
                  width: cardWidth,
                  title: 'Riwayat',
                  backgroundColor: AppColors.primaryColor,
                  imagePath: 'assets/images/icon_masuk.png',
                ),
              ],
            ),
            const SizedBox(height: 26),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Info hari ini',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => _InfoRow(
                title: 'Datang',
                value: controller.isLoadingDaily.value
                    ? 'Memuat...'
                    : controller.datangInfo.value,
              ),
            ),
            const Divider(color: Colors.black54, thickness: 1),
            Obx(
              () => _InfoRow(
                title: 'Pulang',
                value: controller.isLoadingDaily.value
                    ? 'Memuat...'
                    : controller.pulangInfo.value,
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.width,
    required this.title,
    required this.backgroundColor,
    required this.imagePath,
  });

  final double width;
  final String title;
  final Color backgroundColor;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3B000000),
            blurRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Image.asset(imagePath, height: 40, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.pan_tool_alt_outlined,
            size: 38,
            color: Colors.black87,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
