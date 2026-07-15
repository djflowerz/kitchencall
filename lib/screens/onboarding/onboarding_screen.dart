import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  const _OnboardingPage(this.icon, this.title, this.description);
}

const _pages = [
  _OnboardingPage(
    Icons.restaurant,
    'Home-cooked meals,\nmade easy',
    'Book trusted home cooks near you and enjoy delicious, hygienic meals made with love.',
  ),
  _OnboardingPage(
    Icons.search,
    'Choose from amazing\ncooks near you',
    'Browse verified home cooks, explore menus, read reviews and pick your perfect match.',
  ),
  _OnboardingPage(
    Icons.map,
    'Track your cook,\nstay updated',
    'Follow your cook in real time, chat easily and get updates every step of the way.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  void _next() {
    if (_index == _pages.length - 1) {
      context.goNamed('login');
    } else {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () => context.goNamed('login'),
                  child: const Text('Skip'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreenLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, size: 72, color: AppColors.primaryGreen),
                        ),
                        const SizedBox(height: 36),
                        Text(page.title, textAlign: TextAlign.center, style: AppTextStyles.h1),
                        const SizedBox(height: 14),
                        Text(page.description, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _index ? AppColors.primaryGreen : context.surfaceColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                label: _index == _pages.length - 1 ? 'Get Started' : 'Next',
                icon: Icons.arrow_forward,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
