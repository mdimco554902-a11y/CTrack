class DailyLog {
  final String id;
  final String foodName;
  final double caloriesConsumed;
  final String mealType; // e.g., 'Breakfast', 'Lunch', 'Dinner', 'Snack'
  final double servingGrams;
  final double protein;
  final double carbs;
  final double fats;
  final DateTime loggedAt;

  DailyLog({
    required this.id,
    required this.foodName,
    required this.caloriesConsumed,
    required this.mealType,
    this.servingGrams = 100.0,
    this.protein = 0.0,
    this.carbs = 0.0,
    this.fats = 0.0,
    DateTime? loggedAt,
  }) : loggedAt = loggedAt ?? DateTime.now();

  DailyLog copyWith({
    String? id,
    String? foodName,
    double? caloriesConsumed,
    String? mealType,
    double? servingGrams,
    double? protein,
    double? carbs,
    double? fats,
    DateTime? loggedAt,
  }) {
    return DailyLog(
      id: id ?? this.id,
      foodName: foodName ?? this.foodName,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      mealType: mealType ?? this.mealType,
      servingGrams: servingGrams ?? this.servingGrams,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  String toString() {
    return 'DailyLog(id: $id, foodName: $foodName, calories: $caloriesConsumed kcal, mealType: $mealType)';
  }
}
