import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/app_notification.dart';
import '../providers/calorie_tracker_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/theme_mode_toggle_button.dart';
import 'landing_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _calorieController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatsController;

  @override
  void initState() {
    super.initState();
    final tracker = ref.read(calorieTrackerProvider);
    _calorieController = TextEditingController(
      text: tracker.dailyCalorieGoal.toStringAsFixed(0),
    );
    _proteinController = TextEditingController(
      text: tracker.proteinGoal.toStringAsFixed(0),
    );
    _carbsController = TextEditingController(
      text: tracker.carbsGoal.toStringAsFixed(0),
    );
    _fatsController = TextEditingController(
      text: tracker.fatsGoal.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _calorieController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  void _saveGoals() {
    final cals = double.tryParse(_calorieController.text.trim()) ?? 2000.0;
    final protein = double.tryParse(_proteinController.text.trim()) ?? 150.0;
    final carbs = double.tryParse(_carbsController.text.trim()) ?? 230.0;
    final fats = double.tryParse(_fatsController.text.trim()) ?? 65.0;

    ref.read(calorieTrackerProvider.notifier).updateDailyGoal(cals);
    ref.read(calorieTrackerProvider.notifier).updateMacroGoals(
      protein: protein,
      carbs: carbs,
      fats: fats,
    );

    ref.read(userProfileProvider.notifier).updateCustomGoals(
      calories: cals,
      protein: protein,
      carbs: carbs,
      fats: fats,
    );

    AppNotification.showSuccess(context, 'Calorie and macro targets updated!');
  }

  void _confirmResetToday() {
    final isDark = ref.read(isDarkModeProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card(isDark),
        title: Text('Reset Today\'s Meals?', style: TextStyle(color: AppColors.txtPrimary(isDark))),
        content: Text(
          'This will remove all logged meals for the selected date. This action cannot be undone.',
          style: TextStyle(color: AppColors.txtSecondary(isDark)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.txtSecondary(isDark))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(ctx).pop();
              final date = ref.read(calorieTrackerProvider).selectedDate;
              ref.read(calorieTrackerProvider.notifier).resetLogsForDate(date);
              AppNotification.showSuccess(context, 'Reset meals for today.');
            },
            child: const Text('Reset Today'),
          ),
        ],
      ),
    );
  }

  void _loadDemoData() {
    ref.read(calorieTrackerProvider.notifier).loadDemoData();
    AppNotification.showSuccess(context, 'Loaded realistic demo meals!');
  }

  void _confirmLogout(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
            SizedBox(width: 8),
            Text(
              'Log Out of CTrack',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to log out? You will be returned to the landing page.',
          style: TextStyle(color: AppColors.txtSecondary(isDark)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.txtSecondary(isDark))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(100, 42),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LandingScreen()),
                (route) => false,
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroField(String label, TextEditingController controller, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: 'g'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          const ThemeModeToggleButton(size: 20),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.primary),
            tooltip: 'Save Goals',
            onPressed: _saveGoals,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 28,
            vertical: isMobile ? 12 : 22,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Target Goals Section
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.card(isDark),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.brd(isDark)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Nutrition & Calorie Targets',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.txtPrimary(isDark),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: _saveGoals,
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Daily Calories
                    Text(
                      'Daily Calorie Target',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.txtSecondary(isDark),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _calorieController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        suffixText: 'kcal',
                        prefixIcon: Icon(
                          Icons.local_fire_department_rounded,
                          color: AppColors.carbs,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Macro Targets: Protein, Carbs, Fats (responsive layout for narrow screens)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 360;
                        if (isNarrow) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildMacroField('Protein Target', _proteinController, AppColors.protein),
                              const SizedBox(height: 10),
                              _buildMacroField('Carbs Target', _carbsController, AppColors.carbs),
                              const SizedBox(height: 10),
                              _buildMacroField('Fats Target', _fatsController, AppColors.fat),
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: _buildMacroField('Protein Target', _proteinController, AppColors.protein),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildMacroField('Carbs Target', _carbsController, AppColors.carbs),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildMacroField('Fats Target', _fatsController, AppColors.fat),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Preferences: Theme Mode & Unit System
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.card(isDark),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.brd(isDark)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferences',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.txtPrimary(isDark),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Theme Selector Row (Wrap to avoid overflow on mobile)
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'App Color Theme',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.txtPrimary(isDark),
                              ),
                            ),
                            Text(
                              isDark ? 'Dark Mode (Midnight Obsidian)' : 'Light Mode (Clean Slate)',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.txtMuted(isDark),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ThemeModeToggleButton(),
                            const SizedBox(width: 8),
                            Text(
                              isDark ? 'Dark' : 'Light',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.txtPrimary(isDark),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Measurement Units (Wrap to avoid overflow on mobile)
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Measurement Units',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.txtPrimary(isDark),
                              ),
                            ),
                            Text(
                              'Metric (kg, g, cm) or Imperial (lbs, oz)',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.txtMuted(isDark),
                              ),
                            ),
                          ],
                        ),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'Metric', label: Text('Metric')),
                            ButtonSegment(value: 'Imperial', label: Text('Imperial')),
                          ],
                          selected: {profile.unitSystem},
                          onSelectionChanged: (set) {
                            if (set.isNotEmpty) {
                              ref.read(userProfileProvider.notifier).setUnitSystem(set.first);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Data Management Section
              Material(
                color: AppColors.card(isDark),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.brd(isDark)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Management',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.txtPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Reset Today's Meals
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.carbs.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.today_rounded, color: AppColors.carbs, size: 20),
                        ),
                        title: Text('Reset Today\'s Meals', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.txtPrimary(isDark))),
                        subtitle: Text('Removes all meal entries logged for today', style: TextStyle(fontSize: 12, color: AppColors.txtSecondary(isDark))),
                        trailing: Icon(Icons.chevron_right_rounded, color: AppColors.txtMuted(isDark)),
                        onTap: _confirmResetToday,
                      ),
                      Divider(height: 1, color: AppColors.brd(isDark)),

                      // Load Demo Data
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGlow(isDark),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 20),
                        ),
                        title: Text('Reload Demo Meals', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.txtPrimary(isDark))),
                        subtitle: Text('Restores default sample breakfast and lunch', style: TextStyle(fontSize: 12, color: AppColors.txtSecondary(isDark))),
                        trailing: Icon(Icons.chevron_right_rounded, color: AppColors.txtMuted(isDark)),
                        onTap: _loadDemoData,
                      ),
                      Divider(height: 1, color: AppColors.brd(isDark)),

                      // Clear All Meals
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 20),
                        ),
                        title: const Text('Clear All Logs', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.error)),
                        subtitle: Text('Deletes all logged meals across all dates', style: TextStyle(fontSize: 12, color: AppColors.txtSecondary(isDark))),
                        trailing: Icon(Icons.chevron_right_rounded, color: AppColors.txtMuted(isDark)),
                        onTap: () {
                          ref.read(calorieTrackerProvider.notifier).clearAllLogs();
                          AppNotification.showSuccess(context, 'All meal logs have been cleared.');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Account & Session Section (Log Out / Sign Out)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.card(isDark),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.brd(isDark)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account & Session',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.txtPrimary(isDark),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Signed in as ${profile.name} (${profile.email})',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.txtSecondary(isDark),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _confirmLogout(context, isDark),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.35),
                          ),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded, size: 20, color: AppColors.error),
                              SizedBox(width: 10),
                              Text(
                                'Log Out / Sign Out',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // About App Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.card(isDark),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.brd(isDark)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'CTrack Nutrition Tracker',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.txtPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Version 1.0.0 • Clean & Mindful Nutrition Tracking',
                        style: TextStyle(fontSize: 12, color: AppColors.txtMuted(isDark)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
    );
  }
}
