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

class _LockScreenState extends State<LockScreen> with TickerProviderStateMixin {
  static const String _correctPin = '270697';
  String _enteredPin = '';
  bool _isError = false;

  late AnimationController _shakeController;
  late AnimationController _pulseController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
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
    if (_enteredPin.length == 6) _validatePin();
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
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
        transitionsBuilder: (context, animation, secondary, child) => FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut), child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ));
    } else {
      HapticFeedback.vibrate();
      setState(() => _isError = true);
      _shakeController.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) setState(() => _enteredPin = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.oceanGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 800),
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) => Transform.scale(scale: _pulseAnimation.value, child: child),
                          child: const SeaTurtleLogo(size: 90),
                        ),
                      ),
                      const SizedBox(height: 40),
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) => Transform.translate(offset: Offset(_shakeAnimation.value, 0), child: child),
                          child: GlassCard(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                            borderColor: _isError ? AppColors.errorRed.withOpacity(0.6) : AppColors.glassBorder,
                            gradient: _isError ? LinearGradient(colors: [AppColors.errorRed.withOpacity(0.15), AppColors.errorRed.withOpacity(0.05)]) : null,
                            child: Column(
                              children: [
                                Text(_isError ? '✕ CODE INCORRECT' : 'ENTREZ VOTRE CODE PIN',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: _isError ? AppColors.errorRed : AppColors.accentCyan, fontSize: 12, letterSpacing: 2)),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(6, (index) {
                                    final filled = index < _enteredPin.length;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: filled ? AppColors.accentCyan : Colors.white24),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _PinKeypad(onKeyPress: _onKeyPress, onDelete: _onDelete),
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

class _PinKeypad extends StatelessWidget {
  final Function(String) onKeyPress;
  final VoidCallback onDelete;

  const _PinKeypad({required this.onKeyPress, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final buttons = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    return Column(
      children: [
        for (int row = 0; row < 3; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int col = 0; col < 3; col++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () => onKeyPress(buttons[row * 3 + col]),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.brightBlue.withOpacity(0.3), border: Border.all(color: AppColors.accentCyan.withOpacity(0.5))),
                        child: Center(child: Text(buttons[row * 3 + col], style: const TextStyle(color: AppColors.accentCyan, fontSize: 24, fontWeight: FontWeight.w600))),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 86),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.errorRed.withOpacity(0.3), border: Border.all(color: AppColors.errorRed.withOpacity(0.5))),
                  child: const Center(child: Icon(Icons.backspace, color: AppColors.errorRed, size: 24)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
