import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _hrmsIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // In a real app we'd authenticate, here we just navigate to home
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
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
                      onPressed: _login,
                      isFullWidth: true,
                      size: Ux4gButtonSize.lg,
                      child: const Text('Login'),
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
