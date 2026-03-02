import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';
import 'screens/login_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/category_results_screen.dart';
import 'screens/pdf_view_screen.dart';
import 'screens/notifications_screen.dart';

void main() {
  runApp(const RdsoDocumentsApp());
}

class RdsoDocumentsApp extends StatelessWidget {
  const RdsoDocumentsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RDSO Documents',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Ux4gColors.primary),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeDashboard(),
        '/results': (context) => const CategoryResultsScreen(),
        '/pdf': (context) => const PdfViewScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}
