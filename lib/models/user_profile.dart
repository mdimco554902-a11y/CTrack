enum FitnessGoal {
  weightLoss,
  maintenance,
  muscleGain,
}

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive,
}

enum Gender {
  male,
  female,
}

class UserProfile {
  final String name;
  final String email;
  final Gender gender;
  final int age;
  final double weightKg;
  final double heightCm;
  final ActivityLevel activityLevel;
  final FitnessGoal fitnessGoal;
  final String unitSystem; // 'Metric' (kg, cm) or 'Imperial' (lbs, in)
  final double customCalorieGoal;
  final double customProteinGoal;
  final double customCarbsGoal;
  final double customFatsGoal;
  final bool useAutoCalculatedGoals;

  const UserProfile({
    this.name = 'Alex Johnson',
    this.email = 'alex@example.com',
    this.gender = Gender.male,
    this.age = 26,
    this.weightKg = 74.0,
    this.heightCm = 178.0,
    this.activityLevel = ActivityLevel.moderatelyActive,
    this.fitnessGoal = FitnessGoal.maintenance,
    this.unitSystem = 'Metric',
    this.customCalorieGoal = 2200.0,
    this.customProteinGoal = 150.0,
    this.customCarbsGoal = 230.0,
    this.customFatsGoal = 65.0,
    this.useAutoCalculatedGoals = true,
  });

  /// Mifflin-St Jeor Equation for Basal Metabolic Rate (BMR)
  double get bmr {
    if (gender == Gender.male) {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }
  }

  /// Activity Multiplier for Total Daily Energy Expenditure (TDEE)
  double get activityMultiplier {
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extraActive:
        return 1.9;
    }
  }

  /// Total Daily Energy Expenditure
  double get tdee => bmr * activityMultiplier;

  /// Recommended daily calorie intake based on fitness goal
  double get recommendedCalories {
    switch (fitnessGoal) {
      case FitnessGoal.weightLoss:
        // 500 kcal deficit
        final deficit = tdee - 500;
        return deficit < 1200 ? 1200 : deficit;
      case FitnessGoal.maintenance:
        return tdee;
      case FitnessGoal.muscleGain:
        // 350 kcal surplus
        return tdee + 350;
    }
  }

  /// Active Daily Calorie Goal (either auto-calculated or customized)
  double get effectiveCalorieGoal =>
      useAutoCalculatedGoals ? recommendedCalories : customCalorieGoal;

  /// Recommended Protein target (approx 2.0g per kg of bodyweight, or 30% of calories)
  double get recommendedProtein => (weightKg * 2.0).clamp(60.0, 260.0);

  /// Recommended Fats target (approx 25% of daily calories: 9 kcal per gram)
  double get recommendedFats => (effectiveCalorieGoal * 0.25) / 9.0;

  /// Recommended Carbs target (remaining calories: 4 kcal per gram)
  double get recommendedCarbs {
    final proteinCals = recommendedProtein * 4;
    final fatsCals = recommendedFats * 9;
    final remainingCals = effectiveCalorieGoal - (proteinCals + fatsCals);
    final carbs = remainingCals / 4;
    return carbs > 50 ? carbs : 50;
  }

  double get effectiveProteinGoal =>
      useAutoCalculatedGoals ? recommendedProtein : customProteinGoal;

  double get effectiveCarbsGoal =>
      useAutoCalculatedGoals ? recommendedCarbs : customCarbsGoal;

  double get effectiveFatsGoal =>
      useAutoCalculatedGoals ? recommendedFats : customFatsGoal;

  String get activityLevelLabel {
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        return 'Sedentary (Desk job, little exercise)';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active (1-3 days/week)';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active (3-5 days/week)';
      case ActivityLevel.veryActive:
        return 'Very Active (6-7 days/week)';
      case ActivityLevel.extraActive:
        return 'Extremely Active (Physical job & training)';
    }
  }

  String get fitnessGoalLabel {
    switch (fitnessGoal) {
      case FitnessGoal.weightLoss:
        return 'Weight Loss (Caloric Deficit -500 kcal)';
      case FitnessGoal.maintenance:
        return 'Maintain Weight (TDEE Equilibrium)';
      case FitnessGoal.muscleGain:
        return 'Muscle Building (Lean Surplus +350 kcal)';
    }
  }

  UserProfile copyWith({
    String? name,
    String? email,
    Gender? gender,
    int? age,
    double? weightKg,
    double? heightCm,
    ActivityLevel? activityLevel,
    FitnessGoal? fitnessGoal,
    String? unitSystem,
    double? customCalorieGoal,
    double? customProteinGoal,
    double? customCarbsGoal,
    double? customFatsGoal,
    bool? useAutoCalculatedGoals,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      activityLevel: activityLevel ?? this.activityLevel,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      unitSystem: unitSystem ?? this.unitSystem,
      customCalorieGoal: customCalorieGoal ?? this.customCalorieGoal,
      customProteinGoal: customProteinGoal ?? this.customProteinGoal,
      customCarbsGoal: customCarbsGoal ?? this.customCarbsGoal,
      customFatsGoal: customFatsGoal ?? this.customFatsGoal,
      useAutoCalculatedGoals:
          useAutoCalculatedGoals ?? this.useAutoCalculatedGoals,
    );
  }
}
