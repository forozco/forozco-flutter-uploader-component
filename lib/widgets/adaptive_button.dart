import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AdaptivePrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AdaptivePrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          color: AppColors.primaryPink,
          borderRadius: BorderRadius.circular(10),
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const CupertinoActivityIndicator(color: AppColors.white)
              : Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPink,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

class AdaptiveSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AdaptiveSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          color: AppColors.lightPink,
          borderRadius: BorderRadius.circular(10),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.lightPink,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
