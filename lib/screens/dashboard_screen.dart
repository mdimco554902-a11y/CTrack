import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/app_notification.dart';
import '../models/daily_log.dart';
import '../providers/calorie_tracker_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/calorie_progress_ring.dart';
import '../widgets/edit_meal_dialog.dart';
import '../widgets/macro_nutrient_card.dart';
import '../widgets/meal_log_item.dart';
import '../widgets/quick_add_dialog.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/theme_mode_toggle_button.dart';
import 'instructions_screen.dart';
import 'search_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackerState = ref.watch(calorieTrackerProvider);
    final trackerNotifier = ref.read(calorieTrackerProvider.notifier);
    final isDark = ref.watch(isDarkModeProvider);
    final isDesktopWide = !Responsive.isMobile(context);

    const mealCategories = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      appBar: AppBar(
        title: const Text('CTrack Today'),
        actions: [
          const ThemeModeToggleButton(size: 20),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Quick Calorie Add',
            icon: const Icon(Icons.flash_on_rounded, color: AppColors.carbs, size: 22),
            onPressed: () => _showQuickAdd(context, ref, isDark),
          ),
          IconButton(
            tooltip: 'How to Use CTrack',
            icon: const Icon(Icons.help_outline_rounded, size: 22),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const InstructionsScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Adjust Calorie Goal',
            icon: const Icon(Icons.tune_rounded, size: 22),
            onPressed: () => _showGoalDialog(context, ref, trackerState.dailyCalorieGoal, isDark),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktopWide ? 20.0 : 8.0,
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Top Spacing & Date Header & Calorie Ring & Macros
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    children: [
                      _DateNavigator(
                        selectedDate: trackerState.selectedDate,
                        isToday: trackerState.isSelectedDateToday,
                        isDark: isDark,
                        onPreviousDay: () => trackerNotifier.goToPreviousDay(),
                        onNextDay: () => trackerNotifier.goToNextDay(),
                        onPickDate: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: trackerState.selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2035),
                          );
                          if (picked != null) {
                            trackerNotifier.setSelectedDate(picked);
                          }
                        },
                        onTodayTap: () => trackerNotifier.goToToday(),
                      ),
                      const SizedBox(height: 16),

                      // Calorie Progress Ring Anchor
                      CalorieProgressRing(
                        consumed: trackerState.totalCaloriesConsumed,
                        goal: trackerState.dailyCalorieGoal,
                        size: 210,
                      ),

                      const SizedBox(height: 20),

                      // Macro Nutrients Summary Row with target progress
                      Row(
                        children: [
                          MacroNutrientCard(
                            label: 'Protein',
                            amount: trackerState.totalProtein,
                            target: trackerState.proteinGoal,
                            accentColor: AppColors.protein,
                          ),
                          const SizedBox(width: 8),
                          MacroNutrientCard(
                            label: 'Carbs',
                            amount: trackerState.totalCarbs,
                            target: trackerState.carbsGoal,
                            accentColor: AppColors.carbs,
                          ),
                          const SizedBox(width: 8),
                          MacroNutrientCard(
                            label: 'Fats',
                            amount: trackerState.totalFats,
                            target: trackerState.fatsGoal,
                            accentColor: AppColors.fat,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Today's Meals Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's Meals",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.txtPrimary(isDark),
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            '${trackerState.currentDateLogs.length} logged',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.txtMuted(isDark),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              // Categorized Meals List
              if (trackerState.currentDateLogs.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.lunch_dining_outlined,
                            size: 48,
                            color: AppColors.txtMuted(isDark).withValues(alpha: 0.6),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No meals logged for this day',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.txtSecondary(isDark),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap "+ Log Meal" below to record your first meal.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.txtMuted(isDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = mealCategories[index];
                        final categoryLogs = trackerState.getLogsByMealType(category);

                        if (categoryLogs.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final categoryCalories = categoryLogs.fold<double>(
                          0.0,
                          (sum, item) => sum + item.caloriesConsumed,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Header with quick add shortcut
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          category,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.txtPrimary(isDark),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle_outline_rounded,
                                            size: 18,
                                            color: AppColors.primary,
                                          ),
                                          tooltip: 'Add food to $category',
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => SearchScreen(
                                                  initialMealType: category,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${categoryCalories.toStringAsFixed(0)} kcal',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.txtSecondary(isDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Category Meals
                              ...categoryLogs.map(
                                (log) => MealLogItem(
                                  log: log,
                                  onTap: () => _showEditMealDialog(context, ref, log),
                                  onDelete: () {
                                    final deletedLog = log;
                                    trackerNotifier.removeLog(log.id);

                                    // Rock-solid Undo notification that automatically dismisses!
                                    AppNotification.showUndo(
                                      context,
                                      message: 'Removed ${deletedLog.foodName}',
                                      onUndo: () {
                                        trackerNotifier.addLog(deletedLog);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: mealCategories.length,
                    ),
                  ),
                ),

              // Bottom padding for FAB clearance
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          'Log Meal',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
        },
      ),
    );
  }

  void _showEditMealDialog(BuildContext context, WidgetRef ref, DailyLog log) {
    showDialog(
      context: context,
      builder: (ctx) => EditMealDialog(
        log: log,
        onSave: (updated) {
          ref.read(calorieTrackerProvider.notifier).updateLog(updated);
          AppNotification.showSuccess(context, 'Updated ${updated.foodName}');
        },
        onDelete: () {
          ref.read(calorieTrackerProvider.notifier).removeLog(log.id);
          AppNotification.showUndo(
            context,
            message: 'Removed ${log.foodName}',
            onUndo: () {
              ref.read(calorieTrackerProvider.notifier).addLog(log);
            },
          );
        },
      ),
    );
  }

  void _showQuickAdd(BuildContext context, WidgetRef ref, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => QuickAddDialog(
        onAdd: ({
          required String mealType,
          required double calories,
          double protein = 0,
          double carbs = 0,
          double fats = 0,
          String name = 'Quick Calorie Add',
        }) {
          ref.read(calorieTrackerProvider.notifier).quickAddCalories(
            mealType: mealType,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fats: fats,
            name: name,
          );
          AppNotification.showSuccess(
            context,
            'Logged ${calories.toStringAsFixed(0)} kcal to $mealType',
          );
        },
      ),
    );
  }

  void _showGoalDialog(BuildContext context, WidgetRef ref, double currentGoal, bool isDark) {
    final controller = TextEditingController(text: currentGoal.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Daily Calorie Goal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.txtPrimary(isDark),
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'e.g. 2000',
            suffixText: 'kcal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.txtSecondary(isDark))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(90, 40),
            ),
            onPressed: () {
              final newGoal = double.tryParse(controller.text);
              if (newGoal != null && newGoal > 0) {
                ref.read(calorieTrackerProvider.notifier).updateDailyGoal(newGoal);
                AppNotification.showSuccess(
                  context,
                  'Calorie goal updated to ${newGoal.toStringAsFixed(0)} kcal!',
                );
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _DateNavigator extends StatelessWidget {
  final DateTime selectedDate;
  final bool isToday;
  final bool isDark;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onPickDate;
  final VoidCallback onTodayTap;

  const _DateNavigator({
    required this.selectedDate,
    required this.isToday,
    required this.isDark,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onPickDate,
    required this.onTodayTap,
  });

  String _format(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthName = months[date.month - 1];

    if (isToday) {
      return 'Today, $monthName ${date.day}, ${date.year}';
    }

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday, $monthName ${date.day}';
    }

    return '$monthName ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.brd(isDark)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left_rounded, color: AppColors.txtSecondary(isDark)),
            tooltip: 'Previous Day',
            onPressed: onPreviousDay,
          ),
          Expanded(
            child: Center(
              child: InkWell(
                onTap: onPickDate,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          _format(selectedDate),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.txtPrimary(isDark),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isToday) ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: onTodayTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGlow(isDark),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Go Today',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.protein : AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right_rounded, color: AppColors.txtSecondary(isDark)),
            tooltip: 'Next Day',
            onPressed: onNextDay,
          ),
        ],
      ),
    );
  }
}
