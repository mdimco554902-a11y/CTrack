import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/app_notification.dart';
import '../models/food_item.dart';
import '../providers/calorie_tracker_provider.dart';
import '../providers/food_providers.dart';
import '../providers/theme_provider.dart';
import '../widgets/quick_add_dialog.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/theme_mode_toggle_button.dart';
import 'portion_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String initialMealType;

  const SearchScreen({
    super.key,
    this.initialMealType = 'Lunch',
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = const [
    'All',
    'Proteins',
    'Carbs',
    'Fats & Dairy',
    'Fruits & Veggies',
    'Snacks',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFoodSelected(FoodItem food) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PortionScreen(
          foodItem: food,
          defaultMealType: widget.initialMealType,
        ),
      ),
    );
  }

  void _showCreateCustomFoodDialog(bool isDark) {
    final nameCtrl = TextEditingController();
    final caloriesCtrl = TextEditingController();
    final servingCtrl = TextEditingController(text: '100');
    final proteinCtrl = TextEditingController(text: '0');
    final carbsCtrl = TextEditingController(text: '0');
    final fatsCtrl = TextEditingController(text: '0');
    String selectedCat = 'Proteins';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
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
                  // Header with Title and Close 'X' Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGlow(isDark),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Create Custom Food',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.txtPrimary(isDark),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: AppColors.txtMuted(isDark)),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category Selector Pills
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.txtSecondary(isDark),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _categories.where((c) => c != 'All').map((cat) {
                        final isSelected = selectedCat == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () => setDialogState(() => selectedCat = cat),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.cardVariant(isDark),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                cat,
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
                  ),
                  const SizedBox(height: 16),

                  // Food Name
                  Text(
                    'Food Name *',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.txtSecondary(isDark),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Grandma\'s Chicken Soup',
                      prefixIcon: Icon(Icons.restaurant_menu_rounded, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Serving Size and Calories Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Base Serving',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.txtSecondary(isDark),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: servingCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                suffixText: 'g',
                                prefixIcon: Icon(Icons.scale_rounded, color: AppColors.textMuted),
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
                              'Calories (kcal) *',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.txtPrimary(isDark),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: caloriesCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              decoration: const InputDecoration(
                                hintText: 'e.g. 250',
                                suffixText: 'kcal',
                                prefixIcon: Icon(Icons.local_fire_department_rounded, color: AppColors.carbs),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Macros (Optional)
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
                          controller: proteinCtrl,
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
                          controller: carbsCtrl,
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
                          controller: fatsCtrl,
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

                  // Full-Width Primary Create Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      final name = nameCtrl.text.trim();
                      final cals = double.tryParse(caloriesCtrl.text.trim()) ?? 0.0;
                      final serving = double.tryParse(servingCtrl.text.trim()) ?? 100.0;
                      final protein = double.tryParse(proteinCtrl.text.trim()) ?? 0.0;
                      final carbs = double.tryParse(carbsCtrl.text.trim()) ?? 0.0;
                      final fats = double.tryParse(fatsCtrl.text.trim()) ?? 0.0;

                      if (name.isEmpty || cals <= 0) {
                        return;
                      }

                      final customFood = FoodItem(
                        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        category: selectedCat,
                        baseServing: serving,
                        unit: 'g',
                        baseCalories: cals,
                        protein: protein,
                        carbs: carbs,
                        fats: fats,
                        isCustom: true,
                      );

                      ref.read(foodRepositoryProvider).addCustomFood(customFood);
                      ref.read(foodListRevisionProvider.notifier).state++;

                      Navigator.of(ctx).pop();
                      AppNotification.showSuccess(context, 'Added "$name" to your food database!');
                    },
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text(
                      'Create Food',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showQuickAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => QuickAddDialog(
        defaultMealType: widget.initialMealType,
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
          AppNotification.showSuccess(context, 'Logged ${calories.toStringAsFixed(0)} kcal to $mealType');
          Navigator.of(context).pop(); // Safely return to Tracker
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foods = ref.watch(filteredFoodsProvider);
    final currentQuery = ref.watch(foodSearchQueryProvider);
    final selectedCategory = ref.watch(foodSelectedCategoryProvider);
    final isDark = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      appBar: AppBar(
        title: const Text('Add Food'),
        actions: [
          const ThemeModeToggleButton(size: 20),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.flash_on_rounded, color: AppColors.carbs),
            tooltip: 'Quick Calorie Add',
            onPressed: _showQuickAddDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            tooltip: 'Create Custom Food',
            onPressed: () => _showCreateCustomFoodDialog(isDark),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ResponsiveCenter(
        maxWidth: 820,
        child: Column(
          children: [
            // Search Input Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                onChanged: (val) {
                  ref.read(foodSearchQueryProvider.notifier).state = val;
                },
                decoration: InputDecoration(
                  hintText: 'Search foods (e.g. Chicken, Rice, Salmon)...',
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.txtSecondary(isDark)),
                  suffixIcon: currentQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded, color: AppColors.txtMuted(isDark)),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(foodSearchQueryProvider.notifier).state = '';
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),

            // Horizontal Category Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: isDark ? const Color(0xFF1E293B) : AppColors.primaryLight,
                      backgroundColor: AppColors.card(isDark),
                      checkmarkColor: AppColors.primary,
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.brd(isDark),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? (isDark ? AppColors.protein : AppColors.primaryDark)
                            : AppColors.txtSecondary(isDark),
                      ),
                      onSelected: (_) {
                        ref.read(foodSelectedCategoryProvider.notifier).state = cat;
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // Count Subtitle & Quick Add Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCategory == 'All' ? 'Food Database' : '$selectedCategory Options',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.txtSecondary(isDark),
                    ),
                  ),
                  Text(
                    '${foods.length} items',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.txtMuted(isDark),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Food List
            Expanded(
              child: foods.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: AppColors.txtMuted(isDark).withValues(alpha: 0.6),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No foods found for "$currentQuery"',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.txtSecondary(isDark),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                minimumSize: const Size(180, 42),
                              ),
                              onPressed: () => _showCreateCustomFoodDialog(isDark),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: const Text('Add As Custom Food'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      itemCount: foods.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final food = foods[index];
                        return _FoodItemTile(
                          food: food,
                          isDark: isDark,
                          onTap: () => _onFoodSelected(food),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodItemTile extends StatelessWidget {
  final FoodItem food;
  final bool isDark;
  final VoidCallback onTap;

  const _FoodItemTile({
    required this.food,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card(isDark),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.brd(isDark)),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: food.isCustom
                    ? AppColors.carbs.withValues(alpha: 0.12)
                    : AppColors.primaryGlow(isDark),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                food.isCustom ? Icons.bookmark_added_rounded : Icons.restaurant_menu_rounded,
                color: food.isCustom ? AppColors.carbs : AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Name and Macros
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          food.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.txtPrimary(isDark),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (food.isCustom) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.carbs.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Custom',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.carbs,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'per ${food.baseServing.toStringAsFixed(0)}${food.unit} • ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.txtSecondary(isDark),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'P: ${food.protein.toStringAsFixed(1)}g ',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.protein,
                        ),
                      ),
                      Text(
                        'C: ${food.carbs.toStringAsFixed(1)}g ',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.carbs,
                        ),
                      ),
                      Text(
                        'F: ${food.fats.toStringAsFixed(1)}g',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.fat,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Calories & Chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${food.baseCalories.toStringAsFixed(0)} kcal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.txtPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.txtMuted(isDark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
