import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/app_notification.dart';
import '../models/user_profile.dart';
import '../providers/calorie_tracker_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/theme_mode_toggle_button.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;

  late Gender _gender;
  late ActivityLevel _activityLevel;
  late FitnessGoal _fitnessGoal;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _ageController = TextEditingController(text: profile.age.toString());
    _weightController = TextEditingController(text: profile.weightKg.toStringAsFixed(1));
    _heightController = TextEditingController(text: profile.heightCm.toStringAsFixed(0));
    _gender = profile.gender;
    _activityLevel = profile.activityLevel;
    _fitnessGoal = profile.fitnessGoal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final age = int.tryParse(_ageController.text.trim()) ?? 26;
    final weight = double.tryParse(_weightController.text.trim()) ?? 74.0;
    final height = double.tryParse(_heightController.text.trim()) ?? 178.0;

    ref.read(userProfileProvider.notifier).updateProfile(
      name: _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : 'User',
      email: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : 'user@example.com',
      gender: _gender,
      age: age,
      weightKg: weight,
      heightCm: height,
      activityLevel: _activityLevel,
      fitnessGoal: _fitnessGoal,
    );

    AppNotification.showSuccess(context, 'Profile information saved successfully!');
  }

  void _applyRecommendedToTracker() {
    _saveProfile();
    final profile = ref.read(userProfileProvider);
    final recCalories = profile.recommendedCalories;
    final recProtein = profile.recommendedProtein;
    final recCarbs = profile.recommendedCarbs;
    final recFats = profile.recommendedFats;

    ref.read(calorieTrackerProvider.notifier).updateDailyGoal(recCalories);
    ref.read(calorieTrackerProvider.notifier).updateMacroGoals(
      protein: recProtein,
      carbs: recCarbs,
      fats: recFats,
    );

    AppNotification.showSuccess(
      context,
      'Updated Tracker Goal to ${recCalories.toStringAsFixed(0)} kcal / day!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final isDark = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      appBar: AppBar(
        title: const Text('Account Profile'),
        actions: [
          const ThemeModeToggleButton(size: 20),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.primary),
            tooltip: 'Save Profile',
            onPressed: _saveProfile,
          ),
          const SizedBox(width: 8),
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
                // User Avatar & Badges Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card(isDark),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.brd(isDark)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            profile.name.isNotEmpty
                                ? profile.name.trim().substring(0, 1).toUpperCase()
                                : 'A',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.txtPrimary(isDark),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profile.email,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.txtSecondary(isDark),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGlow(isDark),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'CTrack Member • Pro',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.protein : AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // BMR & TDEE Scientific Calculator Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.card(isDark),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: isDark ? 0.1 : 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
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
                              color: AppColors.primaryGlow(isDark),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.calculate_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Energy Expenditure (Mifflin-St Jeor)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.txtPrimary(isDark),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricTile(
                              label: 'Basal Metabolic Rate',
                              value: '${profile.bmr.toStringAsFixed(0)} kcal',
                              caption: 'Base calories burned at rest',
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _MetricTile(
                              label: 'Daily TDEE',
                              value: '${profile.tdee.toStringAsFixed(0)} kcal',
                              caption: 'Maintenance calorie level',
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGlow(isDark),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.recommend_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recommended Target',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.txtSecondary(isDark),
                                    ),
                                  ),
                                  Text(
                                    '${profile.recommendedCalories.toStringAsFixed(0)} kcal / day (${profile.fitnessGoalLabel.split(' ')[0]})',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? AppColors.protein : AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          minimumSize: const Size.fromHeight(42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _applyRecommendedToTracker,
                        icon: const Icon(Icons.sync_rounded, size: 18),
                        label: const Text('Apply Target to Daily Tracker'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Personal Information Form
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
                        'Personal Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.txtPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Full Name
                      Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.txtSecondary(isDark),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.txtMuted(isDark)),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Email Address
                      Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.txtSecondary(isDark),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail_outline_rounded, color: AppColors.txtMuted(isDark)),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Gender Selector
                      Text(
                        'Biological Sex',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.txtSecondary(isDark),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Center(child: Text('Male')),
                              selected: _gender == Gender.male,
                              onSelected: (_) => setState(() => _gender = Gender.male),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ChoiceChip(
                              label: const Center(child: Text('Female')),
                              selected: _gender == Gender.female,
                              onSelected: (_) => setState(() => _gender = Gender.female),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Age, Weight, Height Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Age',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.txtSecondary(isDark),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    suffixText: 'yrs',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weight (kg)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.txtSecondary(isDark),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _weightController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    suffixText: 'kg',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Height (cm)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.txtSecondary(isDark),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _heightController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    suffixText: 'cm',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Activity Level
                      Text(
                        'Daily Activity Level',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.txtSecondary(isDark),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<ActivityLevel>(
                        initialValue: _activityLevel,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        items: ActivityLevel.values.map((lvl) {
                          return DropdownMenuItem(
                            value: lvl,
                            child: Text(
                              lvl.name.replaceAll('Active', ' Active'),
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _activityLevel = val);
                        },
                      ),
                      const SizedBox(height: 18),

                      // Fitness Goal
                      Text(
                        'Fitness Objective',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.txtSecondary(isDark),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<FitnessGoal>(
                        initialValue: _fitnessGoal,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: FitnessGoal.weightLoss,
                            child: Text(
                              'Weight Loss (-500 kcal Deficit)',
                              style: TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DropdownMenuItem(
                            value: FitnessGoal.maintenance,
                            child: Text(
                              'Maintain Weight (TDEE Equilibrium)',
                              style: TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DropdownMenuItem(
                            value: FitnessGoal.muscleGain,
                            child: Text(
                              'Muscle Building (+350 kcal Surplus)',
                              style: TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _fitnessGoal = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save_rounded, size: 20),
                  label: const Text('Save Profile Information'),
                ),
                const SizedBox(height: 24),
              ],
            ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String caption;
  final bool isDark;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.caption,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardVariant(isDark),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.txtSecondary(isDark),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.txtPrimary(isDark),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.txtMuted(isDark),
            ),
          ),
        ],
      ),
    );
  }
}
