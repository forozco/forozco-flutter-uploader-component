import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AdaptiveDialog {
  static Future<void> showMessage({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Aceptar',
  }) async {
    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: Text(buttonText),
            ),
          ],
        ),
      );
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    bool isDestructive = false,
  }) async {
    if (Platform.isIOS) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            CupertinoDialogAction(
              isDestructiveAction: isDestructive,
              isDefaultAction: !isDestructive,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        ),
      );
    }

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static void showSnackBar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.textDark.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      Future.delayed(duration, () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}
