import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../providers/theme_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/theme_mode_toggle_button.dart';

class InstructionsScreen extends ConsumerWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      appBar: AppBar(
        title: const Text('How to Use CTrack'),
        actions: const [
          ThemeModeToggleButton(size: 20),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 16 : 28,
            vertical: Responsive.isMobile(context) ? 12 : 22,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Banner
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Welcome to CTrack',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your mindful companion for calorie and macronutrient tracking. Follow this visual guide to master every feature in the app.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section 1: Quick 4-Step Start
                _SectionCard(
                  title: '⚡ Quick 4-Step Start',
                  icon: Icons.rocket_launch_rounded,
                  iconColor: AppColors.carbs,
                  isDark: isDark,
                  children: [
                    _StepItem(
                      number: '1',
                      title: 'Check Your Daily Goal',
                      description:
                          'The large circular ring shows your remaining calories. Go to the Account tab to calculate your personalized TDEE & daily calorie goal.',
                      isDark: isDark,
                    ),
                    _StepItem(
                      number: '2',
                      title: 'Tap "+ Log Meal"',
                      description:
                          'Click the blue "+ Log Meal" button at the bottom right, or tap the "+" button directly on any meal category header.',
                      isDark: isDark,
                    ),
                    _StepItem(
                      number: '3',
                      title: 'Select Food & Enter Grams',
                      description:
                          'Search from our library of 30+ everyday foods. Type the portion in grams or tap quick chips (50g, 100g, 200g) for real-time nutritional recalculation.',
                      isDark: isDark,
                    ),
                    _StepItem(
                      number: '4',
                      title: 'Tap "Log Meal"',
                      description:
                          'Confirm your meal entry. Your calories, protein, carbs, and fats immediately reflect on the dashboard progress rings and cards.',
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Section 2: Logging & Meals
                _SectionCard(
                  title: '🍽️ Logging & Managing Meals',
                  icon: Icons.restaurant_menu_rounded,
                  iconColor: AppColors.primary,
                  isDark: isDark,
                  children: [
                    _FeatureItem(
                      icon: Icons.search_rounded,
                      title: 'Search & Category Filters',
                      description:
                          'Filter foods by Proteins, Carbs, Fats & Dairy, Fruits & Veggies, or Snacks chips to find ingredients in seconds.',
                      isDark: isDark,
                    ),
                    _FeatureItem(
                      icon: Icons.flash_on_rounded,
                      title: 'Quick Calorie Add',
                      description:
                          'Ate something on the go? Use "Quick Add" from the dashboard top action bar or search screen to record estimated calories and macros instantly without selecting a specific food.',
                      isDark: isDark,
                    ),
                    _FeatureItem(
                      icon: Icons.add_circle_outline_rounded,
                      title: 'Custom Food Creation',
                      description:
                          'Tap "+ Custom Food" on the food search screen to save your own favorite recipes or packaged foods with their nutrition facts.',
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Section 3: Editing, Deleting, and Undo
                _SectionCard(
                  title: '✏️ Editing, Deleting & Undo',
                  icon: Icons.edit_note_rounded,
                  iconColor: AppColors.protein,
                  isDark: isDark,
                  children: [
                    _FeatureItem(
                      icon: Icons.touch_app_rounded,
                      title: 'Tap to Edit Any Logged Meal',
                      description:
                          'Tap on any meal card in the "Today\'s Meals" list to open the editor. You can alter the portion in grams or switch it to another meal type (e.g., Breakfast to Snack).',
                      isDark: isDark,
                    ),
                    _FeatureItem(
                      icon: Icons.delete_outline_rounded,
                      title: 'One-Tap Delete',
                      description:
                          'Tap the trash can icon next to any meal item to remove it from your day.',
                      isDark: isDark,
                    ),
                    _FeatureItem(
                      icon: Icons.undo_rounded,
                      title: 'Instant Undo & Auto-Dismissing Popups',
                      description:
                          'When you delete a meal, a floating notification appears at the bottom with an "UNDO" action and a close ("X") button. Tapping UNDO instantly restores your meal. The popup is guaranteed to smoothly auto-vanish after 4 seconds and never get stuck!',
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Section 4: Daily Ring, Macros & Date Switching
                _SectionCard(
                  title: '📊 Understanding Your Dashboard',
                  icon: Icons.donut_large_rounded,
                  iconColor: AppColors.fat,
                  isDark: isDark,
                  children: [
                    _FeatureItem(
                      icon: Icons.pie_chart_rounded,
                      title: 'Circular Calorie Ring',
                      description:
                          'Displays your consumed calories versus daily target. If you exceed your target, the ring turns amber/red and shows how many calories you are over budget.',
                      isDark: isDark,
                    ),
                    _FeatureItem(
                      icon: Icons.fitness_center_rounded,
                      title: 'Macro Nutrient Cards',
                      description:
                          'Track Protein (Cool Blue), Carbs (Amber), and Fats (Emerald). Each card shows grams consumed and your personal daily macro target progress.',
                      isDark: isDark,
                    ),
                    _FeatureItem(
                      icon: Icons.calendar_today_rounded,
                      title: 'Date Navigation Bar',
                      description:
                          'Use the left and right arrows (<, >) or the calendar icon on the dashboard to look back at previous days or review past food logs.',
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Section 5: Account, BMR & TDEE
                _SectionCard(
                  title: '👤 Account & TDEE Calculator',
                  icon: Icons.person_outline_rounded,
                  iconColor: AppColors.primaryDark,
                  isDark: isDark,
                  children: [
                    _FeatureItem(
                      icon: Icons.calculate_outlined,
                      title: 'Scientific BMR & TDEE Estimation',
                      description:
                          'Enter your weight, height, age, gender, and activity level in the Account screen. CTrack uses the Mifflin-St Jeor formula to determine your maintenance calories.',
                      isDark: isDark,
                    ),
                    _FeatureItem(
                      icon: Icons.tune_rounded,
                      title: 'Goal Presets',
                      description:
                          'Choose between Weight Loss (-500 kcal deficit), Maintenance, or Muscle Gain (+350 kcal surplus). Tap "Apply Recommended Target" to update your daily goals in one click.',
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Section 6: Pro Tips
                _SectionCard(
                  title: '💡 Pro Tips for Tracking Success',
                  icon: Icons.lightbulb_outline_rounded,
                  iconColor: AppColors.carbs,
                  isDark: isDark,
                  children: [
                    _TipItem(
                      tip:
                          'Use a digital kitchen scale whenever possible. Weighing in grams is significantly more accurate than volume estimation (cups or spoons).',
                      isDark: isDark,
                    ),
                    _TipItem(
                      tip:
                          'Weigh foods consistently. Most raw meats lose 20-25% water weight when cooked, while grains like rice and pasta absorb water and expand 2-3x.',
                      isDark: isDark,
                    ),
                    _TipItem(
                      tip:
                          'Log your meals as you eat them or even before eating. Pre-logging helps you budget calories effectively throughout the day.',
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool isDark;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.isDark,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brd(isDark)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.txtPrimary(isDark),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final bool isDark;

  const _StepItem({
    required this.number,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.txtPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.txtSecondary(isDark),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDark;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.txtPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.txtSecondary(isDark),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String tip;
  final bool isDark;

  const _TipItem({required this.tip, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.carbs,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.txtSecondary(isDark),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
