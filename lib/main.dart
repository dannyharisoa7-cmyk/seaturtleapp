// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/budget_provider.dart';
import 'screens/lock_screen.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.deepOcean,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SeaTurtleApp());
}

class SeaTurtleApp extends StatelessWidget {
  const SeaTurtleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BudgetProvider()..loadData(),
      child: MaterialApp(
        title: 'Sea Turtle Grants',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const LockScreen(),
      ),
    );
  }
}
