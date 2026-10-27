class FoodItem {
  final String id;
  final String name;
  final String category;
  final double baseServing; // default 100
  final String unit; // default "g"
  final double baseCalories;
  final double protein;
  final double carbs;
  final double fats;
  final bool isCustom;

  const FoodItem({
    required this.id,
    required this.name,
    this.category = 'General',
    this.baseServing = 100.0,
    this.unit = 'g',
    required this.baseCalories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.isCustom = false,
  });

  /// Calculates scaled calories for a given portion in [unit] (typically grams).
  double caloriesFor(double portion) {
    if (baseServing <= 0) return 0;
    return (portion / baseServing) * baseCalories;
  }

  /// Calculates scaled protein for a given portion.
  double proteinFor(double portion) {
    if (baseServing <= 0) return 0;
    return (portion / baseServing) * protein;
  }

  /// Calculates scaled carbs for a given portion.
  double carbsFor(double portion) {
    if (baseServing <= 0) return 0;
    return (portion / baseServing) * carbs;
  }

  /// Calculates scaled fats for a given portion.
  double fatsFor(double portion) {
    if (baseServing <= 0) return 0;
    return (portion / baseServing) * fats;
  }

  FoodItem copyWith({
    String? id,
    String? name,
    String? category,
    double? baseServing,
    String? unit,
    double? baseCalories,
    double? protein,
    double? carbs,
    double? fats,
    bool? isCustom,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      baseServing: baseServing ?? this.baseServing,
      unit: unit ?? this.unit,
      baseCalories: baseCalories ?? this.baseCalories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  String toString() {
    return 'FoodItem(id: $id, name: $name, calories: $baseCalories kcal, category: $category)';
  }
}
