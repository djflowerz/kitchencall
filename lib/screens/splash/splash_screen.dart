import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: check persisted auth session here and route straight to
    // '/home' if already logged in, per the Splash -> Check Auth flow.
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.goNamed('onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppColors.greenGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.h1,
                  children: const [
                    TextSpan(text: 'Kitchen', style: TextStyle(color: AppColors.primaryGreen)),
                    TextSpan(text: 'Call', style: TextStyle(color: AppColors.secondaryOrange)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(AppConstants.tagline, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 40),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.secondaryOrange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
