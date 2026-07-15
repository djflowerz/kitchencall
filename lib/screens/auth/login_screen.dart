import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  Future<void> _login() async {
    final success = await ref.read(authControllerProvider.notifier).login(
          _identifierController.text,
          _passwordController.text,
        );
    if (success && mounted) context.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back', style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text('Login to continue booking your favorite cooks', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 32),
              TextField(
                controller: _identifierController,
                decoration: const InputDecoration(labelText: 'Email or Phone', hintText: 'you@example.com'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.pushNamed('forgotPassword'),
                  child: const Text('Forgot Password?'),
                ),
              ),
              if (authState.error != null) ...[
                Text(authState.error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              PrimaryButton(label: 'Log In', isLoading: authState.isLoading, onPressed: _login),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('or', style: AppTextStyles.bodySmall)),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              SecondaryButton(label: 'Continue with Google', onPressed: _login),
              const SizedBox(height: 12),
              SecondaryButton(label: 'Continue with Apple', onPressed: _login),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => context.pushNamed('signup'),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium,
                      children: const [
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(text: 'Sign Up', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w600)),
                      ],
                    ),
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
