import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FileUploadItem extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final double progress;
  final bool isUploading;
  final VoidCallback? onRemove;

  const FileUploadItem({
    super.key,
    required this.fileName,
    required this.fileSize,
    this.progress = 0.0,
    this.isUploading = true,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildIOSItem(context);
    }
    return _buildAndroidItem(context);
  }

  Widget _buildIOSItem(BuildContext context) {
    // Colores que se adaptan a dark mode
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final backgroundColor = isDark
        ? CupertinoColors.systemGrey6.darkColor
        : CupertinoColors.systemBackground;
    final iconBackgroundColor = CupertinoColors.systemGrey5.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Dismissible(
      key: Key(fileName),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onRemove?.call();
      },
      confirmDismiss: (_) async {
        HapticFeedback.lightImpact();
        return true;
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: CupertinoColors.systemRed.resolveFrom(context),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          CupertinoIcons.delete,
          color: CupertinoColors.white,
          size: 22,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: separatorColor,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: isUploading
                    ? const CupertinoActivityIndicator()
                    : Icon(
                        _getIOSFileIcon(),
                        color: CupertinoColors.systemBlue.resolveFrom(context),
                        size: 22,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        fileSize,
                        style: TextStyle(
                          fontSize: 13,
                          color: secondaryLabelColor,
                        ),
                      ),
                      if (!isUploading) ...[
                        const SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.checkmark_circle_fill,
                          color: CupertinoColors.systemGreen.resolveFrom(context),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Completado',
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemGreen.resolveFrom(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (isUploading) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: CupertinoColors.systemGrey4.resolveFrom(context),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CupertinoColors.systemBlue.resolveFrom(context),
                        ),
                        minHeight: 3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 32,
              onPressed: () {
                HapticFeedback.lightImpact();
                onRemove?.call();
              },
              child: Icon(
                CupertinoIcons.xmark_circle_fill,
                color: CupertinoColors.systemGrey3.resolveFrom(context),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidItem(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dismissible(
      key: Key(fileName),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onRemove?.call();
      },
      confirmDismiss: (_) async {
        HapticFeedback.lightImpact();
        return true;
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete_outline,
          color: colorScheme.onError,
          size: 24,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        elevation: 0,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: isUploading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.primary,
                            ),
                          ),
                        )
                      : Icon(
                          _getAndroidFileIcon(),
                          color: colorScheme.primary,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          fileSize,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (!isUploading) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Completado',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (isUploading) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onRemove?.call();
                },
                icon: Icon(
                  Icons.cancel,
                  color: colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIOSFileIcon() {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return CupertinoIcons.doc_fill;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return CupertinoIcons.photo_fill;
      case 'doc':
      case 'docx':
        return CupertinoIcons.doc_text_fill;
      default:
        return CupertinoIcons.doc_fill;
    }
  }

  IconData _getAndroidFileIcon() {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }
}
