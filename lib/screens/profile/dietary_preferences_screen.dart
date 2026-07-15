import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/auth_provider.dart';

const _dietOptions = ['Vegan', 'Vegetarian', 'Halal', 'Kosher', 'Low Salt', 'Low Sugar', 'Gluten-Free', 'Lactose-Free'];
const _allergyOptions = ['Peanuts', 'Tree Nuts', 'Shellfish', 'Dairy', 'Eggs', 'Soy', 'Gluten'];

class DietaryPreferencesScreen extends ConsumerStatefulWidget {
  const DietaryPreferencesScreen({super.key});

  @override
  ConsumerState<DietaryPreferencesScreen> createState() => _DietaryPreferencesScreenState();
}

class _DietaryPreferencesScreenState extends ConsumerState<DietaryPreferencesScreen> {
  late Set<String> _preferences;
  late Set<String> _allergies;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    _preferences = {...?user?.dietaryPreferences};
    _allergies = {...?user?.allergies};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dietary Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dietary preferences', style: AppTextStyles.h3),
            const SizedBox(height: 4),
            Text('Cooks will tailor menus to these where possible', style: AppTextStyles.bodySmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dietOptions.map((option) {
                final selected = _preferences.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: selected,
                  selectedColor: AppColors.primaryGreenLight,
                  checkmarkColor: AppColors.primaryGreen,
                  onSelected: (v) => setState(() => v ? _preferences.add(option) : _preferences.remove(option)),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Allergies', style: AppTextStyles.h3),
            const SizedBox(height: 4),
            Text('We\'ll flag these to your cook on every booking', style: AppTextStyles.bodySmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allergyOptions.map((option) {
                final selected = _allergies.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: selected,
                  selectedColor: AppColors.secondaryOrangeLight,
                  checkmarkColor: AppColors.secondaryOrange,
                  onSelected: (v) => setState(() => v ? _allergies.add(option) : _allergies.remove(option)),
                );
              }).toList(),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Save Preferences',
              onPressed: () {
                ref.read(authControllerProvider.notifier).updateDietaryPreferences(
                      preferences: _preferences.toList(),
                      allergies: _allergies.toList(),
                    );
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preferences saved')));
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
