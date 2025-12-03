import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    // Colores adaptativos para dark mode
    final borderColor = CupertinoColors.systemGrey3.resolveFrom(context);
    final backgroundColor = CupertinoColors.systemGrey6.resolveFrom(context).withOpacity(0.5);
    final iconContainerColor = CupertinoColors.systemGrey5.resolveFrom(context);
    final iconColor = CupertinoColors.systemGrey.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final tertiaryLabelColor = CupertinoColors.tertiaryLabel.resolveFrom(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: DottedBorder(
        borderRadius: BorderRadius.circular(12),
        color: borderColor,
        strokeWidth: 1.5,
        dashPattern: const [6, 4],
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: iconContainerColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.cloud_upload,
                  size: 32,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                color: iconContainerColor,
                borderRadius: BorderRadius.circular(10),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onTap?.call();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.folder,
                      size: 18,
                      color: labelColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Seleccionar archivo',
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Máximo ${maxFileSizeMB}MB',
                style: TextStyle(
                  color: secondaryLabelColor,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                allowedExtensions.map((e) => e.toUpperCase()).join(', '),
                style: TextStyle(
                  color: tertiaryLabelColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAndroidDropzone(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(16),
        child: DottedBorder(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.outlineVariant,
          strokeWidth: 1.5,
          dashPattern: const [8, 4],
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 20),
                FilledButton.tonalIcon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onTap?.call();
                  },
                  icon: const Icon(Icons.folder_open_outlined, size: 20),
                  label: const Text('Seleccionar archivo'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Máximo ${maxFileSizeMB}MB',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  allowedExtensions.map((e) => e.toUpperCase()).join(', '),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget para dibujar borde punteado estilo Material 3
class DottedBorder extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;

  const DottedBorder({
    super.key,
    required this.child,
    required this.borderRadius,
    required this.color,
    this.strokeWidth = 1,
    this.dashPattern = const [5, 3],
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(
        borderRadius: borderRadius,
        color: color,
        strokeWidth: strokeWidth,
        dashPattern: dashPattern,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;

  _DottedBorderPainter({
    required this.borderRadius,
    required this.color,
    required this.strokeWidth,
    required this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    final rrect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
    path.addRRect(rrect);

    final dashPath = _createDashedPath(path);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source) {
    final dashPath = Path();
    final metricsIterator = source.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      final metric = metricsIterator.current;
      double distance = 0.0;
      bool draw = true;
      int dashIndex = 0;

      while (distance < metric.length) {
        final length = dashPattern[dashIndex % dashPattern.length];
        if (draw) {
          dashPath.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
        dashIndex++;
      }
    }

    return dashPath;
  }

  @override
  bool shouldRepaint(covariant _DottedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
