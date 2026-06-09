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

    final shellPaint = Paint()..color = AppColors.accentCyan..style = PaintingStyle.fill;
    final lightPaint = Paint()..color = Colors.white.withOpacity(0.3)..style = PaintingStyle.fill;
    final darkPaint = Paint()..color = AppColors.deepOcean.withOpacity(0.5)..style = PaintingStyle.fill;
    final flipperPaint = Paint()..color = AppColors.brightBlue..style = PaintingStyle.fill;

    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 42 * scale, height: 34 * scale), shellPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 5 * scale, cy - 5 * scale), width: 16 * scale, height: 10 * scale), lightPaint);

    final headPath = Path()..addOval(Rect.fromCenter(center: Offset(cx, cy - 22 * scale), width: 18 * scale, height: 16 * scale));
    canvas.drawPath(headPath, flipperPaint);

    final eyePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx + 4 * scale, cy - 24 * scale), 2.5 * scale, eyePaint);
    canvas.drawCircle(Offset(cx + 4 * scale, cy - 24 * scale), 1.2 * scale, darkPaint);
    canvas.drawCircle(Offset(cx + 5 * scale, cy - 25 * scale), 0.5 * scale, eyePaint);

    canvas.drawCircle(Offset(cx + 1 * scale, cy - 14.5 * scale), 1 * scale, darkPaint);
    canvas.drawCircle(Offset(cx + 4 * scale, cy - 14.5 * scale), 1 * scale, darkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
