import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ux4g/ux4g.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _hrmsIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _hrmsIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final hrmsId = _hrmsIdController.text.trim();
    final password = _passwordController.text;

    if (hrmsId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both HRMS ID and password')),
      );
      return;
    }

    final auth = context.read<AuthService>();
    final success = await auth.login(hrmsId, password);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Ux4gScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Ux4gSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Confidential badge
              const Ux4gBadge(
                label: 'Confidential System',
                variant: Ux4gAlertVariant.danger,
              ),
              const SizedBox(height: Ux4gSpacing.xl),
              
              // App Logo / Title
              const Icon(Icons.shield, size: 64, color: Ux4gColors.primary),
              const SizedBox(height: Ux4gSpacing.md),
              const Text(
                'RDSO Documents',
                style: TextStyle(
                  fontSize: Ux4gTypography.sizeH3,
                  fontWeight: Ux4gTypography.weightBold,
                  color: Ux4gColors.primary,
                ),
              ),
              const SizedBox(height: Ux4gSpacing.xxl),
              
              // Login Form Card
              Ux4gCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Ux4gTypography.sizeH4,
                        fontWeight: Ux4gTypography.weightSemiBold,
                      ),
                    ),
                    const SizedBox(height: Ux4gSpacing.lg),
                    Ux4gTextField(
                      controller: _hrmsIdController,
                      label: 'HRMS ID',
                      hint: 'Enter your HRMS ID',
                      prefixIcon: const Icon(Icons.person),
                    ),
                    const SizedBox(height: Ux4gSpacing.md),
                    Ux4gTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    const SizedBox(height: Ux4gSpacing.xl),
                    Ux4gButton(
                      onPressed: auth.isLoading ? null : _login,
                      isFullWidth: true,
                      size: Ux4gButtonSize.lg,
                      child: auth.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Ux4gColors.white),
                            )
                          : const Text('Login'),
                    ),
                    const SizedBox(height: Ux4gSpacing.md),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: const Text('Don\'t have an account? Register'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
