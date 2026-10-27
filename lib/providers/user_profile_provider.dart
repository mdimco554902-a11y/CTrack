import 'package:flutter_riverpod/legacy.dart';
import '../models/user_profile.dart';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(const UserProfile());

  void updateProfile({
    String? name,
    String? email,
    Gender? gender,
    int? age,
    double? weightKg,
    double? heightCm,
    ActivityLevel? activityLevel,
    FitnessGoal? fitnessGoal,
    String? unitSystem,
  }) {
    state = state.copyWith(
      name: name,
      email: email,
      gender: gender,
      age: age,
      weightKg: weightKg,
      heightCm: heightCm,
      activityLevel: activityLevel,
      fitnessGoal: fitnessGoal,
      unitSystem: unitSystem,
    );
  }

  void updateCustomGoals({
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
  }) {
    state = state.copyWith(
      useAutoCalculatedGoals: false,
      customCalorieGoal: calories,
      customProteinGoal: protein,
      customCarbsGoal: carbs,
      customFatsGoal: fats,
    );
  }

  void setUseAutoCalculatedGoals(bool value) {
    state = state.copyWith(useAutoCalculatedGoals: value);
  }

  void setUnitSystem(String unit) {
    state = state.copyWith(unitSystem: unit);
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
