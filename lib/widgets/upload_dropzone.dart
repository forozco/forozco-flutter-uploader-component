import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class UploadDropzone extends StatelessWidget {
  final VoidCallback? onTap;
  final int maxFileSizeMB;
  final List<String> allowedExtensions;

  const UploadDropzone({
    super.key,
    this.onTap,
    this.maxFileSizeMB = 5,
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'gif', 'pdf'],
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildIOSDropzone(context);
    }
    return _buildAndroidDropzone(context);
  }

  Widget _buildIOSDropzone(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: CupertinoColors.systemGrey4,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.cloud_upload,
            size: 48,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(height: 16),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            onPressed: () {
              HapticFeedback.lightImpact();
              onTap?.call();
            },
            child: const Text('Seleccionar archivo'),
          ),
          const SizedBox(height: 16),
          Text(
            'Máximo ${maxFileSizeMB}MB',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            allowedExtensions.map((e) => e.toUpperCase()).join(', '),
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAndroidDropzone(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 48,
                color: Colors.grey.shade600,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onTap?.call();
                },
                icon: const Icon(Icons.folder_open, size: 18),
                label: const Text('Seleccionar archivo'),
              ),
              const SizedBox(height: 16),
              Text(
                'Máximo ${maxFileSizeMB}MB',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                allowedExtensions.map((e) => e.toUpperCase()).join(', '),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
