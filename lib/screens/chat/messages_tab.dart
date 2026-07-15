import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/cook_provider.dart';

class MessagesTab extends ConsumerWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cooksAsync = ref.watch(allCooksProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text('Messages', style: AppTextStyles.h2),
          ),
          Expanded(
            child: cooksAsync.when(
              data: (cooks) => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: cooks.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final cook = cooks[i];
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(cook.photoUrl)),
                    title: Text(cook.name, style: AppTextStyles.h3),
                    subtitle: Text(
                      i == 0 ? "Hi! I'm on my way 👋" : 'Thank you for booking with me!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall,
                    ),
                    trailing: i == 0
                        ? Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: AppColors.secondaryOrange, shape: BoxShape.circle),
                            child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 11)),
                          )
                        : null,
                    onTap: () => context.pushNamed(
                      'chat',
                      pathParameters: {'cookId': cook.id},
                      extra: cook.name,
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
