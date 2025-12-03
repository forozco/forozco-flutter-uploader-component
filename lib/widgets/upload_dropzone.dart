import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class UploadDropzone extends StatelessWidget {
  final VoidCallback? onTap;

  const UploadDropzone({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: AppColors.borderGray,
          strokeWidth: 1.5,
          dashWidth: 8,
          dashSpace: 4,
          radius: 8,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/Carga.svg',
                width: 50,
                height: 50,
                colorFilter: ColorFilter.mode(
                  AppColors.textGray.withOpacity(0.5),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.lightPink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Explora tus archivos',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tamaño máximo por archivo: 5MB',
                style: TextStyle(
                  color: AppColors.textGray,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tipo de archivos permitidos: JPG, PNG, GIF, PDF',
                style: TextStyle(
                  color: AppColors.textGray,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  UploadIconPainter({required this.color, this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Caja abierta arriba (U shape) - más ancha
    final boxPath = Path();
    boxPath.moveTo(w * 0.15, h * 0.4);
    boxPath.lineTo(w * 0.15, h * 0.82);
    boxPath.lineTo(w * 0.85, h * 0.82);
    boxPath.lineTo(w * 0.85, h * 0.4);
    canvas.drawPath(boxPath, paint);

    // Flecha hacia arriba
    final arrowPath = Path();
    arrowPath.moveTo(w * 0.5, h * 0.68);
    arrowPath.lineTo(w * 0.5, h * 0.12);
    canvas.drawPath(arrowPath, paint);

    // Punta de flecha - más abierta
    final arrowHead = Path();
    arrowHead.moveTo(w * 0.28, h * 0.32);
    arrowHead.lineTo(w * 0.5, h * 0.12);
    arrowHead.lineTo(w * 0.72, h * 0.32);
    canvas.drawPath(arrowHead, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
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

      while (distance < metric.length) {
        final length = draw ? dashWidth : dashSpace;
        if (draw) {
          dashPath.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }

    return dashPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
