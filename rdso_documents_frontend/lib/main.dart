import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ux4g/ux4g.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/category_results_screen.dart';
import 'screens/pdf_view_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/admin/user_management_screen.dart';
import 'screens/admin/create_document_screen.dart';
import 'screens/admin/audit_logs_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService()..init(),
      child: const RdsoDocumentsApp(),
    ),
  );
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
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeDashboard(),
        '/results': (context) => const CategoryResultsScreen(),
        '/pdf': (context) => const PdfViewScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/admin/users': (context) => const UserManagementScreen(),
        '/admin/create-document': (context) => const CreateDocumentScreen(),
        '/admin/logs': (context) => const AuditLogsScreen(),
      },
    );
  }
}
