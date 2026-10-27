import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/app_notification.dart';
import '../models/daily_log.dart';
import '../models/food_item.dart';
import '../providers/calorie_tracker_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/theme_mode_toggle_button.dart';

class PortionScreen extends ConsumerStatefulWidget {
  final FoodItem foodItem;
  final String defaultMealType;

  const PortionScreen({
    super.key,
    required this.foodItem,
    this.defaultMealType = 'Lunch',
  });

  @override
  ConsumerState<PortionScreen> createState() => _PortionScreenState();
}

class _PortionScreenState extends ConsumerState<PortionScreen> {
  late final TextEditingController _gramsController;
  late String _selectedMealType;

  late double _currentGrams;
  late double _calculatedCalories;
  late double _calculatedProtein;
  late double _calculatedCarbs;
  late double _calculatedFats;

  final List<String> _mealTypes = const [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  final List<double> _quickPortions = const [50, 100, 150, 200, 250];

  @override
  void initState() {
    super.initState();
    _selectedMealType = widget.defaultMealType;
    _currentGrams = widget.foodItem.baseServing;
    _gramsController = TextEditingController(
      text: _currentGrams.toStringAsFixed(0),
    );
    _recalculateMacros(_currentGrams);
  }

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }

  /// Real-time calculation based on user input
  void _recalculateMacros(double grams) {
    _currentGrams = grams;
    if (widget.foodItem.baseServing <= 0 || grams <= 0) {
      _calculatedCalories = 0.0;
      _calculatedProtein = 0.0;
      _calculatedCarbs = 0.0;
      _calculatedFats = 0.0;
      return;
    }

    final multiplier = grams / widget.foodItem.baseServing;
    _calculatedCalories = widget.foodItem.baseCalories * multiplier;
    _calculatedProtein = widget.foodItem.protein * multiplier;
    _calculatedCarbs = widget.foodItem.carbs * multiplier;
    _calculatedFats = widget.foodItem.fats * multiplier;
  }

  void _onGramsChanged(String value) {
    setState(() {
      final parsed = double.tryParse(value.trim()) ?? 0.0;
      _recalculateMacros(parsed);
    });
  }

  void _setPortion(double grams) {
    setState(() {
      _gramsController.text = grams.toStringAsFixed(0);
      _recalculateMacros(grams);
    });
  }

  void _logMeal() {
    if (_currentGrams <= 0) {
      AppNotification.showError(context, 'Please enter a valid portion greater than 0g.');
      return;
    }

    final activeDate = ref.read(calorieTrackerProvider).selectedDate;

    // Create new daily log entry for active date
    final newLog = DailyLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      foodName: widget.foodItem.name,
      caloriesConsumed: _calculatedCalories,
      mealType: _selectedMealType,
      servingGrams: _currentGrams,
      protein: _calculatedProtein,
      carbs: _calculatedCarbs,
      fats: _calculatedFats,
      loggedAt: activeDate,
    );

    // Save to Riverpod StateNotifier
    ref.read(calorieTrackerProvider.notifier).addLog(newLog);

    // Provide user feedback and pop back to Dashboard
    AppNotification.showSuccess(
      context,
      'Logged ${_currentGrams.toStringAsFixed(0)}g of ${widget.foodItem.name} to $_selectedMealType',
    );

    // Safely pop PortionScreen and SearchScreen back to Dashboard/Tracker
    Navigator.of(context).pop();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.foodItem;
    final isDark = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      appBar: AppBar(
        title: const Text('Portion Calculator'),
        actions: const [
          ThemeModeToggleButton(size: 20),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ResponsiveCenter(
                  maxWidth: 720,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Food Header & Baseline Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.card(isDark),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.brd(isDark)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGlow(isDark),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.restaurant_rounded,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.txtPrimary(isDark),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Baseline: ${food.baseServing.toStringAsFixed(0)}${food.unit} = ${food.baseCalories.toStringAsFixed(0)} kcal',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.txtSecondary(isDark),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Divider(color: AppColors.brd(isDark), height: 1),
                            ),
                            // Baseline Macro Breakdown Badges
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _BaselineMacroBadge(
                                  label: 'Base Protein',
                                  value: '${food.protein.toStringAsFixed(1)}g',
                                  color: AppColors.protein,
                                ),
                                _BaselineMacroBadge(
                                  label: 'Base Carbs',
                                  value: '${food.carbs.toStringAsFixed(1)}g',
                                  color: AppColors.carbs,
                                ),
                                _BaselineMacroBadge(
                                  label: 'Base Fats',
                                  value: '${food.fats.toStringAsFixed(1)}g',
                                  color: AppColors.fat,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Meal Type Selector
                      Text(
                        'Log To Meal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.txtPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: _mealTypes.map((type) {
                          final isSelected = _selectedMealType == type;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedMealType = type),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : AppColors.card(isDark),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.brd(isDark),
                                  ),
                                ),
                                child: Text(
                                  type,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : AppColors.txtSecondary(isDark),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Portion Input Field
                      Text(
                        'Your Portion (grams)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.txtPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _gramsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: _onGramsChanged,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.txtPrimary(isDark),
                        ),
                        decoration: InputDecoration(
                          suffixText: 'g',
                          suffixStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.txtSecondary(isDark),
                          ),
                          prefixIcon: const Icon(
                            Icons.scale_rounded,
                            color: AppColors.primary,
                          ),
                          hintText: 'Enter portion in grams',
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Quick Portion Presets
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _quickPortions.map((grams) {
                            final isCurrent = (_currentGrams - grams).abs() < 0.1;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text('${grams.toStringAsFixed(0)}g'),
                                selected: isCurrent,
                                selectedColor: isDark ? const Color(0xFF1E293B) : AppColors.primaryLight,
                                backgroundColor: AppColors.card(isDark),
                                side: BorderSide(
                                  color: isCurrent ? AppColors.primary : AppColors.brd(isDark),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isCurrent
                                      ? (isDark ? AppColors.protein : AppColors.primaryDark)
                                      : AppColors.txtSecondary(isDark),
                                ),
                                onSelected: (_) => _setPortion(grams),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Reactive Real-Time Results Banner
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGlow(isDark),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Calculated Nutritional Value',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.txtSecondary(isDark),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  _calculatedCalories.toStringAsFixed(0),
                                  style: TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.txtPrimary(isDark),
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'kcal',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.txtSecondary(isDark),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Real-Time Calculated Macro Cards
                            Row(
                              children: [
                                _CalculatedMacroTile(
                                  label: 'Protein',
                                  grams: _calculatedProtein,
                                  color: AppColors.protein,
                                  isDark: isDark,
                                ),
                                const SizedBox(width: 8),
                                _CalculatedMacroTile(
                                  label: 'Carbs',
                                  grams: _calculatedCarbs,
                                  color: AppColors.carbs,
                                  isDark: isDark,
                                ),
                                const SizedBox(width: 8),
                                _CalculatedMacroTile(
                                  label: 'Fats',
                                  grams: _calculatedFats,
                                  color: AppColors.fat,
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Fixed Action: "Log Meal" button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.card(isDark),
                border: Border(
                  top: BorderSide(color: AppColors.brd(isDark)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ResponsiveCenter(
                maxWidth: 720,
                child: ElevatedButton.icon(
                  onPressed: _logMeal,
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                  label: Text(
                    'Log ${_calculatedCalories.toStringAsFixed(0)} kcal to $_selectedMealType',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BaselineMacroBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _BaselineMacroBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _CalculatedMacroTile extends StatelessWidget {
  final String label;
  final double grams;
  final Color color;
  final bool isDark;

  const _CalculatedMacroTile({
    required this.label,
    required this.grams,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.card(isDark),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.brd(isDark)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${grams.toStringAsFixed(1)}g',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.txtPrimary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
