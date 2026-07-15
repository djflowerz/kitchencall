import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/theme_provider.dart';

void _showInfoDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
    ),
  );
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final resolvedBrightness = themeMode == ThemeMode.system
        ? MediaQuery.platformBrightnessOf(context)
        : (themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light);
    final isDark = resolvedBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionLabel('Notifications'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: _pushNotifications,
            activeColor: AppColors.primaryGreen,
            onChanged: (v) => setState(() => _pushNotifications = v),
          ),
          SwitchListTile(
            title: const Text('Email Notifications'),
            value: _emailNotifications,
            activeColor: AppColors.primaryGreen,
            onChanged: (v) => setState(() => _emailNotifications = v),
          ),
          SwitchListTile(
            title: const Text('SMS Notifications'),
            value: _smsNotifications,
            activeColor: AppColors.primaryGreen,
            onChanged: (v) => setState(() => _smsNotifications = v),
          ),
          const _SectionLabel('Appearance'),
          RadioListTile<ThemeMode>(
            title: const Text('System default'),
            subtitle: Text('Currently ${isDark ? 'dark' : 'light'} on this device', style: const TextStyle(fontSize: 12)),
            value: ThemeMode.system,
            groupValue: themeMode,
            activeColor: AppColors.primaryGreen,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setMode(v!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeMode,
            activeColor: AppColors.primaryGreen,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setMode(v!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            activeColor: AppColors.primaryGreen,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setMode(v!),
          ),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: _language,
              underline: const SizedBox(),
              items: ['English', 'Kiswahili']
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (v) => setState(() => _language = v ?? _language),
            ),
          ),
          const _SectionLabel('Legal'),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showInfoDialog(context, 'Privacy Policy', 'Your privacy policy content goes here.'),
          ),
          ListTile(
            title: const Text('Terms & Conditions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showInfoDialog(context, 'Terms & Conditions', 'Your terms and conditions go here.'),
          ),
          ListTile(
            title: const Text('About KitchenCall'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showInfoDialog(context, 'About KitchenCall', 'KitchenCall v1.0.0\nGood Food. Home. Love.'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(text, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
    );
  }
}
