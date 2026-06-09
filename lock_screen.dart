// lib/screens/lock_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/sea_turtle_logo.dart';
import 'dashboard_screen.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with TickerProviderStateMixin {
  static const String _correctPin = '270697';
  String _enteredPin = '';
  bool _isError = false;
  int _errorCount = 0;

  late AnimationController _shakeController;
  late AnimationController _pulseController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
        parent: _shakeController, curve: Curves.easeInOut));

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onKeyPress(String digit) {
    HapticFeedback.lightImpact();
    if (_enteredPin.length >= 6) return;
    setState(() {
      _isError = false;
      _enteredPin += digit;
    });

    if (_enteredPin.length == 6) {
      _validatePin();
    }
  }

  void _onDelete() {
    HapticFeedback.selectionClick();
    if (_enteredPin.isEmpty) return;
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      _isError = false;
    });
  }

  Future<void> _validatePin() async {
    await Future.delayed(const Duration(milliseconds: 150));

    if (_enteredPin == _correctPin) {
      HapticFeedback.heavyImpact();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const DashboardScreen(),
          transitionsBuilder: (context, animation, secondary, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation, curve: Curves.easeInOut),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } else {
      HapticFeedback.vibrate();
      setState(() {
        _isError = true;
        _errorCount++;
      });
      _shakeController.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) {
        setState(() {
          _enteredPin = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.oceanGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Ocean wave decoration top ──
              _OceanWaves(),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      FadeInDown(
                        duration: const Duration(milliseconds: 800),
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) => Transform.scale(
                            scale: _pulseAnimation.value,
                            child: child,
                          ),
                          child: const SeaTurtleLogo(size: 90),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // PIN dots
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) => Transform.translate(
                            offset: Offset(_shakeAnimation.value, 0),
                            child: child,
                          ),
                          child: GlassCard(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 20),
                            borderColor: _isError
                                ? AppColors.errorRed.withOpacity(0.6)
                                : AppColors.glassBorder,
                            gradient: _isError
                                ? LinearGradient(
                                    colors: [
                                      AppColors.errorRed.withOpacity(0.15),
                                      AppColors.errorRed.withOpacity(0.05),
                                    ],
                                  )
                                : null,
                            child: Column(
                              children: [
                                Text(
                                  _isError
                                      ? '✕ CODE INCORRECT'
                                      : 'ENTREZ VOTRE CODE PIN',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: _isError
                                            ? AppColors.errorRed
                                            : AppColors.accentCyan,
                                        fontSize: 12,
                                        letterSpacing: 2,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(6, (index) {
                                    final filled = index < _enteredPin.length;
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: filled
                                            ? (_isError
                                                ? AppColors.errorRed
                                                : AppColors.accentCyan)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: filled
                                              ? Colors.transparent
                                              : Colors.white.withOpacity(0.4),
                                          width: 1.5,
                                        ),
                                        boxShadow: filled
                                            ? [
                                                BoxShadow(
                                                  color: (_isError
                                                          ? AppColors.errorRed
                                                          : AppColors
                                                              .accentCyan)
                                                      .withOpacity(0.6),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                )
                                              ]
                                            : null,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Numpad
                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        child: _NumPad(
                          onKeyPress: _onKeyPress,
                          onDelete: _onDelete,
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (_errorCount > 0)
                        FadeIn(
                          child: Text(
                            'Tentatives incorrectes : $_errorCount',
                            style:
                                TextStyle(
                                    color: AppColors.errorRed.withOpacity(0.7),
                                    fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── NumPad Widget ────────────────────────────────────────────────────────────

class _NumPad extends StatelessWidget {
  final void Function(String) onKeyPress;
  final VoidCallback onDelete;

  const _NumPad({required this.onKeyPress, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'del'],
    ];

    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              if (key.isEmpty) return const SizedBox(width: 84, height: 60);
              if (key == 'del') {
                return _KeyButton(
                  label: '⌫',
                  onTap: onDelete,
                  isSpecial: true,
                );
              }
              return _KeyButton(
                label: key,
                onTap: () => onKeyPress(key),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _KeyButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSpecial;

  const _KeyButton({
    required this.label,
    required this.onTap,
    this.isSpecial = false,
  });

  @override
  State<_KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<_KeyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88)
        .animate(CurvedAnimation(parent: _pressController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) {
          _pressController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.isSpecial
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.14),
                        Colors.white.withOpacity(0.06),
                      ],
                    ),
              color: widget.isSpecial ? Colors.transparent : null,
              border: Border.all(
                color: Colors.white.withOpacity(widget.isSpecial ? 0 : 0.2),
                width: 1,
              ),
              boxShadow: widget.isSpecial
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.brightBlue.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSpecial
                      ? AppColors.accentCyan.withOpacity(0.7)
                      : Colors.white,
                  fontSize: widget.label == '⌫' ? 22 : 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Ocean Waves Decoration ───────────────────────────────────────────────────

class _OceanWaves extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: CustomPaint(
        painter: _WavePainter(),
        size: Size(MediaQuery.of(context).size.width, 60),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.brightBlue.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.5);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.5 +
          8 * _sin(x * 0.02 + 1) +
          4 * _sin(x * 0.05);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = AppColors.accentCyan.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, size.height * 0.6);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.65 +
          6 * _sin(x * 0.03 + 2) +
          3 * _sin(x * 0.07 + 1);
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  double _sin(double x) {
    double result = x;
    double term = x;
    for (int n = 1; n <= 8; n++) {
      term *= -x * x / ((2 * n + 1) * (2 * n));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
