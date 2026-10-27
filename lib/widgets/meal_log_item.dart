import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/daily_log.dart';

class MealLogItem extends StatelessWidget {
  final DailyLog log;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MealLogItem({
    super.key,
    required this.log,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brd(isDark)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Meal icon avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGlow(isDark),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

                // Food name and portion
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.foodName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.txtPrimary(isDark),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${log.servingGrams.toStringAsFixed(0)}g • P: ${log.protein.toStringAsFixed(1)}g  C: ${log.carbs.toStringAsFixed(1)}g  F: ${log.fats.toStringAsFixed(1)}g',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.txtSecondary(isDark),
                        ),
                      ),
                    ],
                  ),
                ),

                // Calories badge and actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${log.caloriesConsumed.toStringAsFixed(0)} kcal',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.protein : AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap to edit',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.txtMuted(isDark),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: AppColors.txtMuted(isDark),
                        ),
                        tooltip: 'Delete meal',
                        onPressed: onDelete,
                        splashRadius: 20,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
