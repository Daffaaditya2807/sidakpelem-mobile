import 'package:flutter/material.dart';
import 'package:sidak_desa_mobile/core/const/app_colors.dart';

class AppBottomNavbar extends StatelessWidget {
  const AppBottomNavbar({
    required this.currentIndex,
    required this.onTabSelected,
    super.key,
    this.onCenterTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onCenterTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            top: 20,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFECECEC),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 8,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavItem(
                    icon: Icons.menu_book_outlined,
                    isSelected: currentIndex == 0,
                    onTap: () => onTabSelected(0),
                  ),
                  const SizedBox(width: 72),
                  _NavItem(
                    icon: Icons.person_outline,
                    isSelected: currentIndex == 1,
                    onTap: () => onTabSelected(1),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onCenterTap,
            child: Container(
              width: 74,
              height: 74,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 24,
      icon: Icon(
        icon,
        size: 34,
        color: isSelected
            ? AppColors.primaryColor
            : AppColors.primaryColor.withOpacity(0.8),
      ),
    );
  }
}
