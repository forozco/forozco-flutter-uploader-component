import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AdaptiveBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const AdaptiveBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoTabBar(context);
    }
    return _buildMaterialBottomNav(context);
  }

  Widget _buildCupertinoTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: CupertinoTabBar(
          backgroundColor: AppColors.primaryPurple,
          activeColor: AppColors.white,
          inactiveColor: AppColors.white.withOpacity(0.6),
          currentIndex: currentIndex,
          onTap: onTap,
          border: null,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              label: 'Calendario',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.add_circled),
              label: 'Registro',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.question_circle),
              label: 'Ayuda',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialBottomNav(BuildContext context) {
    return NavigationBar(
      backgroundColor: AppColors.primaryPurple,
      indicatorColor: AppColors.white.withOpacity(0.2),
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: AppColors.white.withOpacity(0.6)),
          selectedIcon: const Icon(Icons.home, color: AppColors.white),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_today_outlined, color: AppColors.white.withOpacity(0.6)),
          selectedIcon: const Icon(Icons.calendar_today, color: AppColors.white),
          label: 'Calendario',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_box_outlined, color: AppColors.white.withOpacity(0.6)),
          selectedIcon: const Icon(Icons.add_box, color: AppColors.white),
          label: 'Registro',
        ),
        NavigationDestination(
          icon: Icon(Icons.help_outline, color: AppColors.white.withOpacity(0.6)),
          selectedIcon: const Icon(Icons.help, color: AppColors.white),
          label: 'Ayuda',
        ),
      ],
    );
  }
}
