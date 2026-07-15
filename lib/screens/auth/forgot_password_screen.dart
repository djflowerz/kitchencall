import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _controller = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  Future<void> _send() async {
    setState(() => _loading = true);
    await ref.read(authRepositoryProvider).sendPasswordReset(_controller.text);
    setState(() {
      _loading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mark_email_read_outlined, size: 72, color: AppColors.primaryGreen),
                  const SizedBox(height: 20),
                  Text('Check your inbox', style: AppTextStyles.h2, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    'We sent a password reset link to ${_controller.text}',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reset your password', style: AppTextStyles.h1),
                  const SizedBox(height: 8),
                  Text(
                    "Enter your email or phone number and we'll send you a reset link.",
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Email or Phone')),
                  const SizedBox(height: 20),
                  PrimaryButton(label: 'Send Reset Link', isLoading: _loading, onPressed: _send),
                ],
              ),
      ),
    );
  }
}
