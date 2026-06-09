// lib/widgets/sea_turtle_logo.dart
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class SeaTurtleLogo extends StatelessWidget {
  final double size;
  final bool showLabel;

  const SeaTurtleLogo({super.key, this.size = 80, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [AppColors.brightBlue, AppColors.midBlue],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentCyan.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: CustomPaint(
            painter: _TurtlePainter(),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.accentGradient.createShader(bounds),
            child: Text(
              'SEA TURTLE',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: size * 0.22,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
            ),
          ),
          Text(
            'GRANTS MANAGEMENT',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: size * 0.1,
                  letterSpacing: 2,
                  color: AppColors.softWhite.withOpacity(0.6),
                ),
          ),
        ],
      ],
    );
  }
}

class _TurtlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = size.width / 100;

    // Colors
    final shellPaint = Paint()
      ..color = AppColors.accentCyan
      ..style = PaintingStyle.fill;

    final lightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final darkPaint = Paint()
      ..color = AppColors.deepOcean.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final flipperPaint = Paint()
      ..color = AppColors.brightBlue
      ..style = PaintingStyle.fill;

    // ─── Body / Shell ──────────────────────────────────────────────────
    final bodyPath = Path()
      ..addOval(Rect.fromCenter(
          center: Offset(cx, cy),
          width: 42 * scale,
          height: 34 * scale));
    canvas.drawPath(bodyPath, shellPaint);

    // Shell hexagonal pattern
    final patternPaint = Paint()
      ..color = AppColors.midBlue.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * scale;

    _drawHex(canvas, cx, cy, 10 * scale, patternPaint);
    _drawHex(canvas, cx - 12 * scale, cy - 5 * scale, 7 * scale, patternPaint);
    _drawHex(canvas, cx + 12 * scale, cy - 5 * scale, 7 * scale, patternPaint);
    _drawHex(canvas, cx - 8 * scale, cy + 8 * scale, 7 * scale, patternPaint);
    _drawHex(canvas, cx + 8 * scale, cy + 8 * scale, 7 * scale, patternPaint);

    // Shell highlight
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - 5 * scale, cy - 5 * scale),
          width: 16 * scale,
          height: 10 * scale),
      lightPaint,
    );

    // ─── Head ──────────────────────────────────────────────────────────
    final headPath = Path()
      ..addOval(Rect.fromCenter(
          center: Offset(cx, cy - 22 * scale),
          width: 18 * scale,
          height: 16 * scale));
    canvas.drawPath(headPath, flipperPaint);

    // Eye
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx + 4 * scale, cy - 24 * scale), 2.5 * scale, eyePaint);
    canvas.drawCircle(Offset(cx + 4 * scale, cy - 24 * scale), 1.2 * scale, darkPaint);
    // Eye shine
    canvas.drawCircle(Offset(cx + 5 * scale, cy - 25 * scale), 0.5 * scale, eyePaint);

    // Nose dots
    canvas.drawCircle(Offset(cx + 1 * scale, cy - 14.5 * scale), 1 * scale, darkPaint);
    canvas.drawCircle(Offset(cx + 4 * scale, cy - 14.5 * scale), 1 * scale, darkPaint);

    // ─── Front Flippers ────────────────────────────────────────────────
    final lfFlipPath = Path();
    lfFlipPath.moveTo(cx - 18 * scale, cy - 6 * scale);
    lfFlipPath.quadraticBezierTo(
        cx - 35 * scale, cy - 20 * scale, cx - 38 * scale, cy - 8 * scale);
    lfFlipPath.quadraticBezierTo(
        cx - 32 * scale, cy - 4 * scale, cx - 20 * scale, cy);
    lfFlipPath.close();
    canvas.drawPath(lfFlipPath, flipperPaint);

    final rfFlipPath = Path();
    rfFlipPath.moveTo(cx + 18 * scale, cy - 6 * scale);
    rfFlipPath.quadraticBezierTo(
        cx + 35 * scale, cy - 20 * scale, cx + 38 * scale, cy - 8 * scale);
    rfFlipPath.quadraticBezierTo(
        cx + 32 * scale, cy - 4 * scale, cx + 20 * scale, cy);
    rfFlipPath.close();
    canvas.drawPath(rfFlipPath, flipperPaint);

    // ─── Rear Flippers ─────────────────────────────────────────────────
    final lrFlipPath = Path();
    lrFlipPath.moveTo(cx - 16 * scale, cy + 12 * scale);
    lrFlipPath.quadraticBezierTo(
        cx - 28 * scale, cy + 22 * scale, cx - 24 * scale, cy + 28 * scale);
    lrFlipPath.quadraticBezierTo(
        cx - 18 * scale, cy + 20 * scale, cx - 12 * scale, cy + 15 * scale);
    lrFlipPath.close();
    canvas.drawPath(lrFlipPath, flipperPaint);

    final rrFlipPath = Path();
    rrFlipPath.moveTo(cx + 16 * scale, cy + 12 * scale);
    rrFlipPath.quadraticBezierTo(
        cx + 28 * scale, cy + 22 * scale, cx + 24 * scale, cy + 28 * scale);
    rrFlipPath.quadraticBezierTo(
        cx + 18 * scale, cy + 20 * scale, cx + 12 * scale, cy + 15 * scale);
    rrFlipPath.close();
    canvas.drawPath(rrFlipPath, flipperPaint);

    // ─── Tail ──────────────────────────────────────────────────────────
    final tailPath = Path();
    tailPath.moveTo(cx - 4 * scale, cy + 16 * scale);
    tailPath.quadraticBezierTo(cx, cy + 28 * scale, cx + 4 * scale, cy + 16 * scale);
    tailPath.close();
    canvas.drawPath(tailPath, flipperPaint);
  }

  void _drawHex(Canvas canvas, double cx, double cy, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * 3.14159 / 180;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double cos(double radians) => _cos(radians);
  double sin(double radians) => _sin(radians);

  double _cos(double x) {
    // Taylor series approximation for cos
    double result = 1.0;
    double term = 1.0;
    for (int n = 1; n <= 10; n++) {
      term *= -x * x / (2 * n * (2 * n - 1));
      result += term;
    }
    return result;
  }

  double _sin(double x) {
    double result = x;
    double term = x;
    for (int n = 1; n <= 10; n++) {
      term *= -x * x / ((2 * n + 1) * (2 * n));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
