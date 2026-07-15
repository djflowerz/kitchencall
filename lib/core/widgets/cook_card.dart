import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/cook_model.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

/// Large featured-style card: photo, name, cuisines, rating, price, book CTA.
class CookCard extends StatelessWidget {
  const CookCard({
    super.key,
    required this.cook,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  final CookModel cook;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 230,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: context.surfaceColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.surfaceColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: cook.photoUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(height: 120, color: context.surfaceColors.divider),
                    errorWidget: (_, __, ___) => Container(
                      height: 120,
                      color: context.surfaceColors.divider,
                      child: const Icon(Icons.person, size: 40, color: AppColors.textMuted),
                    ),
                  ),
                ),
                if (cook.isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _Badge(text: 'Featured', color: AppColors.secondaryOrange),
                  ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFavorite ? AppColors.error : AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(cook.name, style: AppTextStyles.h3, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      if (cook.isVerified)
                        const Icon(Icons.verified, size: 16, color: AppColors.primaryGreen),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cook.cuisines.join(' • '),
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.starGold),
                      const SizedBox(width: 3),
                      Text('${cook.rating} (${cook.reviewCount})', style: AppTextStyles.bodySmall),
                      const SizedBox(width: 8),
                      const Icon(Icons.location_on, size: 13, color: AppColors.textMuted),
                      Text(' ${cook.distanceKm.toStringAsFixed(1)} km', style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'From ${AppConstants.currencySymbol} ${cook.startingPrice.toStringAsFixed(0)}',
                    style: AppTextStyles.price,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact row-style card used in search results / nearby lists.
class CookListTile extends StatelessWidget {
  const CookListTile({super.key, required this.cook, required this.onTap});
  final CookModel cook;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.surfaceColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.surfaceColors.divider),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: cook.photoUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      width: 70,
                      height: 70,
                      color: context.surfaceColors.divider,
                      child: const Icon(Icons.person),
                    ),
                  ),
                ),
                if (cook.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(cook.name, style: AppTextStyles.h3, overflow: TextOverflow.ellipsis)),
                      if (cook.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 15, color: AppColors.primaryGreen),
                      ],
                    ],
                  ),
                  Text(cook.cuisines.join(' • '), style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: AppColors.starGold),
                      Text(' ${cook.rating}', style: AppTextStyles.bodySmall),
                      Text(' • ${cook.distanceKm.toStringAsFixed(1)} km away', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'From\n${AppConstants.currencySymbol} ${cook.startingPrice.toStringAsFixed(0)}',
              textAlign: TextAlign.right,
              style: AppTextStyles.price.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }
}
