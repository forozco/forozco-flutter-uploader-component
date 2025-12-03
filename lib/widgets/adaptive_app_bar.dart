import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const AdaptiveAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoAppBar(context);
    }
    return _buildMaterialAppBar(context);
  }

  Widget _buildCupertinoAppBar(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: AppColors.primaryPurple,
      border: null,
      leading: onBack != null
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onBack,
              child: const Icon(
                CupertinoIcons.back,
                color: AppColors.white,
              ),
            )
          : null,
      middle: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: actions != null && actions!.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            )
          : null,
    );
  }

  Widget _buildMaterialAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryPurple,
      elevation: 0,
      leading: onBack != null
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.white,
              ),
              onPressed: onBack,
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: actions,
    );
  }
}
