import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class QuickAddDialog extends StatefulWidget {
  final String defaultMealType;
  final void Function({
    required String mealType,
    required double calories,
    double protein,
    double carbs,
    double fats,
    String name,
  }) onAdd;

  const QuickAddDialog({
    super.key,
    this.defaultMealType = 'Lunch',
    required this.onAdd,
  });

  @override
  State<QuickAddDialog> createState() => _QuickAddDialogState();
}

class _QuickAddDialogState extends State<QuickAddDialog> {
  late final TextEditingController _caloriesController;
  late final TextEditingController _nameController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatsController;
  late String _selectedMealType;

  final List<String> _mealTypes = const [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  @override
  void initState() {
    super.initState();
    _caloriesController = TextEditingController();
    _nameController = TextEditingController(text: 'Quick Meal');
    _proteinController = TextEditingController(text: '0');
    _carbsController = TextEditingController(text: '0');
    _fatsController = TextEditingController(text: '0');
    _selectedMealType = widget.defaultMealType;
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _nameController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  void _submit() {
    final calories = double.tryParse(_caloriesController.text.trim()) ?? 0.0;
    if (calories <= 0) {
      return;
    }

    final protein = double.tryParse(_proteinController.text.trim()) ?? 0.0;
    final carbs = double.tryParse(_carbsController.text.trim()) ?? 0.0;
    final fats = double.tryParse(_fatsController.text.trim()) ?? 0.0;
    final name = _nameController.text.trim().isEmpty
        ? 'Quick Calorie Add'
        : _nameController.text.trim();

    widget.onAdd(
      mealType: _selectedMealType,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fats: fats,
      name: name,
    );

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '⚡ Quick Add Calories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.txtPrimary(isDark),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.txtMuted(isDark)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Meal Type Selector
              Row(
                children: _mealTypes.map((type) {
                  final isSelected = _selectedMealType.toLowerCase() == type.toLowerCase();
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
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
              const SizedBox(height: 16),

              // Item Name
              Text(
                'Description / Name',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.txtSecondary(isDark),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Afternoon Smoothie',
                  prefixIcon: Icon(Icons.edit_note_rounded, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 14),

              // Calories Field
              Text(
                'Calories (kcal) *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.txtPrimary(isDark),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _caloriesController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                decoration: const InputDecoration(
                  hintText: 'e.g. 350',
                  suffixText: 'kcal',
                  prefixIcon: Icon(Icons.local_fire_department_rounded, color: AppColors.carbs),
                ),
              ),
              const SizedBox(height: 14),

              // Optional Macros Row
              Text(
                'Macros (Optional)',
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
                    child: TextField(
                      controller: _proteinController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Protein (g)',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _carbsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Carbs (g)',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _fatsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Fats (g)',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Submit Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _submit,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Add to Log'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
