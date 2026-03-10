import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ux4g/ux4g.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _hrmsIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _hrmsIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final hrmsId = _hrmsIdController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (hrmsId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('HRMS ID and password are required')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 8 characters')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final auth = context.read<AuthService>();
    final error = await auth.register(
      hrmsId,
      password,
      email: email.isNotEmpty ? email : null,
      phone: phone.isNotEmpty ? phone : null,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Your account is pending approval.'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
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
              const Icon(Icons.person_add, size: 64, color: Ux4gColors.primary),
              const SizedBox(height: Ux4gSpacing.md),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: Ux4gTypography.sizeH3,
                  fontWeight: Ux4gTypography.weightBold,
                  color: Ux4gColors.primary,
                ),
              ),
              const SizedBox(height: Ux4gSpacing.sm),
              const Text(
                'Your account will be reviewed before activation',
                style: TextStyle(color: Ux4gColors.gray600, fontSize: Ux4gTypography.sizeBody2),
              ),
              const SizedBox(height: Ux4gSpacing.xxl),
              Ux4gCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Ux4gTypography.sizeH4,
                        fontWeight: Ux4gTypography.weightSemiBold,
                      ),
                    ),
                    const SizedBox(height: Ux4gSpacing.lg),
                    Ux4gTextField(
                      controller: _hrmsIdController,
                      label: 'HRMS ID *',
                      hint: 'Enter your HRMS ID',
                      prefixIcon: const Icon(Icons.badge),
                    ),
                    const SizedBox(height: Ux4gSpacing.md),
                    Ux4gTextField(
                      controller: _emailController,
                      label: 'Email (optional)',
                      hint: 'Enter your email',
                      prefixIcon: const Icon(Icons.email),
                    ),
                    const SizedBox(height: Ux4gSpacing.md),
                    Ux4gTextField(
                      controller: _phoneController,
                      label: 'Phone Number (optional)',
                      hint: '10-digit phone number',
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    const SizedBox(height: Ux4gSpacing.md),
                    Ux4gTextField(
                      controller: _passwordController,
                      label: 'Password *',
                      hint: 'Minimum 8 characters',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    const SizedBox(height: Ux4gSpacing.md),
                    Ux4gTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password *',
                      hint: 'Re-enter your password',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    const SizedBox(height: Ux4gSpacing.xl),
                    Ux4gButton(
                      onPressed: _isLoading ? null : _register,
                      isFullWidth: true,
                      size: Ux4gButtonSize.lg,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Ux4gColors.white),
                            )
                          : const Text('Register'),
                    ),
                    const SizedBox(height: Ux4gSpacing.md),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Already have an account? Login'),
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
