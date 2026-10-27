import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/daily_log.dart';

class EditMealDialog extends StatefulWidget {
  final DailyLog log;
  final ValueChanged<DailyLog> onSave;
  final VoidCallback onDelete;

  const EditMealDialog({
    super.key,
    required this.log,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditMealDialog> createState() => _EditMealDialogState();
}

class _EditMealDialogState extends State<EditMealDialog> {
  late final TextEditingController _gramsController;
  late String _selectedMealType;
  late double _currentGrams;
  late double _calculatedCalories;
  late double _calculatedProtein;
  late double _calculatedCarbs;
  late double _calculatedFats;

  // Compute unit ratios based on existing log
  late double _calsPerGram;
  late double _proteinPerGram;
  late double _carbsPerGram;
  late double _fatsPerGram;

  final List<String> _mealTypes = const [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  @override
  void initState() {
    super.initState();
    _currentGrams = widget.log.servingGrams > 0 ? widget.log.servingGrams : 100.0;
    _selectedMealType = widget.log.mealType;
    _gramsController = TextEditingController(
      text: _currentGrams.toStringAsFixed(0),
    );

    _calsPerGram = widget.log.caloriesConsumed / _currentGrams;
    _proteinPerGram = widget.log.protein / _currentGrams;
    _carbsPerGram = widget.log.carbs / _currentGrams;
    _fatsPerGram = widget.log.fats / _currentGrams;

    _calculatedCalories = widget.log.caloriesConsumed;
    _calculatedProtein = widget.log.protein;
    _calculatedCarbs = widget.log.carbs;
    _calculatedFats = widget.log.fats;
  }

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }

  void _onGramsChanged(String val) {
    setState(() {
      final grams = double.tryParse(val.trim()) ?? 0.0;
      _currentGrams = grams;
      _calculatedCalories = grams * _calsPerGram;
      _calculatedProtein = grams * _proteinPerGram;
      _calculatedCarbs = grams * _carbsPerGram;
      _calculatedFats = grams * _fatsPerGram;
    });
  }

  void _save() {
    if (_currentGrams <= 0) return;

    final updated = widget.log.copyWith(
      servingGrams: _currentGrams,
      caloriesConsumed: _calculatedCalories,
      protein: _calculatedProtein,
      carbs: _calculatedCarbs,
      fats: _calculatedFats,
      mealType: _selectedMealType,
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: AppColors.card(isDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Logged Meal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.txtPrimary(isDark),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.log.foodName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.protein : AppColors.primaryDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.txtMuted(isDark)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Meal Category Picker
              Text(
                'Meal Type',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.txtSecondary(isDark),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: _mealTypes.map((type) {
                  final isSelected = _selectedMealType.toLowerCase() == type.toLowerCase();
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedMealType = type),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.cardVariant(isDark),
                            borderRadius: BorderRadius.circular(10),
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
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // Grams Input
              Text(
                'Portion (grams)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.txtSecondary(isDark),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _gramsController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: _onGramsChanged,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.scale_rounded, color: AppColors.primary),
                  suffixText: 'g',
                ),
              ),
              const SizedBox(height: 16),

              // Calculated result banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryGlow(isDark),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      '${_calculatedCalories.toStringAsFixed(0)} kcal',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.txtPrimary(isDark),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'P: ${_calculatedProtein.toStringAsFixed(1)}g',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.protein,
                          ),
                        ),
                        Text(
                          'C: ${_calculatedCarbs.toStringAsFixed(1)}g',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.carbs,
                          ),
                        ),
                        Text(
                          'F: ${_calculatedFats.toStringAsFixed(1)}g',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.fat,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Actions
              Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onDelete();
                    },
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text('Delete'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _save,
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
