import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.embedded = false});

  /// When true, this widget is hosted inside [MainNavigationScreen]'s
  /// IndexedStack and should not render its own Scaffold/back button.
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;

    final content = SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (embedded) Text('Profile', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(radius: 32, backgroundColor: AppColors.primaryGreenLight, child: Icon(Icons.person, size: 34, color: AppColors.primaryGreen)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.fullName ?? 'Guest', style: AppTextStyles.h2),
                    Text(user?.phone ?? '', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => context.pushNamed('editProfile')),
            ],
          ),
          const SizedBox(height: 24),
          _MenuTile(icon: Icons.location_on_outlined, label: 'Saved Addresses', onTap: () => context.pushNamed('addresses')),
          _MenuTile(icon: Icons.credit_card_outlined, label: 'Payment Methods', onTap: () => context.pushNamed('paymentMethods')),
          _MenuTile(icon: Icons.account_balance_wallet_outlined, label: 'Wallet', onTap: () => context.pushNamed('wallet')),
          _MenuTile(icon: Icons.card_membership_outlined, label: 'Subscriptions', onTap: () => context.pushNamed('subscriptionPlans')),
          _MenuTile(icon: Icons.favorite_border, label: 'Favorites', onTap: () => context.pushNamed('favorites')),
          _MenuTile(icon: Icons.restaurant_menu_outlined, label: 'Dietary Preferences', onTap: () => context.pushNamed('dietaryPreferences')),
          _MenuTile(icon: Icons.notifications_none_rounded, label: 'Notifications', onTap: () => context.pushNamed('notifications')),
          _MenuTile(icon: Icons.settings_outlined, label: 'Settings', onTap: () => context.pushNamed('settings')),
          _MenuTile(icon: Icons.help_outline, label: 'Help & Support', onTap: () => context.pushNamed('helpSupport')),
          const SizedBox(height: 12),
          _MenuTile(
            icon: Icons.logout,
            label: 'Log Out',
            color: AppColors.error,
            onTap: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.goNamed('login');
            },
          ),
        ],
      ),
    );

    if (embedded) return content;
    return Scaffold(appBar: AppBar(title: const Text('Profile')), body: content);
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap, this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? AppColors.textDark),
      title: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: color)),
      trailing: color == null ? const Icon(Icons.chevron_right, color: AppColors.textMuted) : null,
      onTap: onTap,
    );
  }
}
