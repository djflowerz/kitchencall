import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

class BookingProgressBar extends StatelessWidget {
  const BookingProgressBar({super.key, required this.step, required this.total});
  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i < step;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: active ? AppColors.primaryGreen : context.surfaceColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
