// lib/widgets/glass_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double blurStrength;
  final Color? borderColor;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.blurStrength = 12,
    this.borderColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(20);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.10),
                    Colors.white.withOpacity(0.04),
                  ],
                ),
            borderRadius: radius,
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;
  final IconData? icon;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.accentColor,
    this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: accentColor, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                label.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: accentColor,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
