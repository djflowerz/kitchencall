import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class _NotificationItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
  bool unread;
  _NotificationItem(this.icon, this.color, this.title, this.subtitle, this.time, this.unread);
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotificationItem> _items = [
    _NotificationItem(Icons.directions_walk, AppColors.primaryGreen, 'Chef Amina is on the way', 'Arriving in 15 mins', '2 mins ago', true),
    _NotificationItem(Icons.chat_bubble_outline, AppColors.info, 'New message', 'Chef David sent you a message', '1 hour ago', true),
    _NotificationItem(Icons.payment, AppColors.primaryGreen, 'Payment successful', 'Your payment of KES 1,400 was successful', '2 hours ago', false),
    _NotificationItem(Icons.card_giftcard, AppColors.secondaryOrange, 'Weekend offer', '20% off meal prep bookings this weekend', '1 day ago', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              for (final item in _items) {
                item.unread = false;
              }
            }),
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final item = _items[i];
          return ListTile(
            onTap: () => setState(() => item.unread = false),
            leading: CircleAvatar(backgroundColor: item.color.withValues(alpha: 0.12), child: Icon(item.icon, color: item.color, size: 20)),
            title: Text(item.title, style: AppTextStyles.h3),
            subtitle: Text(item.subtitle, style: AppTextStyles.bodySmall),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.time, style: AppTextStyles.caption),
                if (item.unread) ...[
                  const SizedBox(height: 4),
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.secondaryOrange, shape: BoxShape.circle)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
