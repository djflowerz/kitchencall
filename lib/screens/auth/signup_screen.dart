import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _agreed = false;

  Future<void> _submit() async {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms & Conditions')),
      );
      return;
    }
    final success = await ref.read(authControllerProvider.notifier).signUp(
          fullName: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (success && mounted) context.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create your account', style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text('Sign up to get started', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 28),
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name')),
              const SizedBox(height: 14),
              TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number')),
              const SizedBox(height: 14),
              TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 14),
              TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
              const SizedBox(height: 14),
              TextField(controller: _confirmController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(value: _agreed, onChanged: (v) => setState(() => _agreed = v ?? false)),
                  const Expanded(child: Text('I agree to the Terms & Conditions and Privacy Policy')),
                ],
              ),
              const SizedBox(height: 12),
              PrimaryButton(label: 'Sign Up', isLoading: authState.isLoading, onPressed: _submit),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
