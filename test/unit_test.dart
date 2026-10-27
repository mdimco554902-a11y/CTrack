import 'package:flutter_test/flutter_test.dart';
import 'package:ctrack/models/daily_log.dart';
import 'package:ctrack/models/food_item.dart';
import 'package:ctrack/models/user_profile.dart';
import 'package:ctrack/providers/calorie_tracker_provider.dart';
import 'package:ctrack/repositories/mock_food_repository.dart';

void main() {
  group('CalorieTrackerNotifier tests', () {
    late CalorieTrackerNotifier notifier;

    setUp(() {
      notifier = CalorieTrackerNotifier();
    });

    test('Initial state has seed logs and calculates total calories', () {
      final state = notifier.state;
      expect(state.dailyCalorieGoal, 2200.0);
      expect(state.currentDateLogs.isNotEmpty, true);
      expect(state.totalCaloriesConsumed, greaterThan(0));
      expect(state.remainingCalories, greaterThan(0));
    });

    test('addLog increases total calories and macros', () {
      final initialConsumed = notifier.state.totalCaloriesConsumed;
      final newLog = DailyLog(
        id: 'test_log_1',
        foodName: 'Test Food',
        caloriesConsumed: 250.0,
        mealType: 'Dinner',
        servingGrams: 100.0,
        protein: 20.0,
        carbs: 30.0,
        fats: 5.0,
        loggedAt: notifier.state.selectedDate,
      );

      notifier.addLog(newLog);

      expect(notifier.state.totalCaloriesConsumed, initialConsumed + 250.0);
      expect(notifier.state.getLogsByMealType('Dinner').any((l) => l.id == 'test_log_1'), true);
    });

    test('updateLog modifies existing log values', () {
      final newLog = DailyLog(
        id: 'test_update_log',
        foodName: 'Update Food',
        caloriesConsumed: 100.0,
        mealType: 'Snack',
        servingGrams: 50.0,
        protein: 5.0,
        carbs: 10.0,
        fats: 2.0,
        loggedAt: notifier.state.selectedDate,
      );
      notifier.addLog(newLog);

      final updatedLog = newLog.copyWith(
        servingGrams: 100.0,
        caloriesConsumed: 200.0,
        protein: 10.0,
      );
      notifier.updateLog(updatedLog);

      final found = notifier.state.logs.firstWhere((l) => l.id == 'test_update_log');
      expect(found.caloriesConsumed, 200.0);
      expect(found.servingGrams, 100.0);
      expect(found.protein, 10.0);
    });

    test('removeLog removes entry from state', () {
      final newLog = DailyLog(
        id: 'to_remove',
        foodName: 'Remove Me',
        caloriesConsumed: 300.0,
        mealType: 'Lunch',
        loggedAt: notifier.state.selectedDate,
      );
      notifier.addLog(newLog);
      expect(notifier.state.logs.any((l) => l.id == 'to_remove'), true);

      notifier.removeLog('to_remove');
      expect(notifier.state.logs.any((l) => l.id == 'to_remove'), false);
    });

    test('Date switching navigates between days', () {
      final initialDate = notifier.state.selectedDate;
      notifier.goToPreviousDay();
      expect(notifier.state.selectedDate.day, initialDate.subtract(const Duration(days: 1)).day);

      notifier.goToNextDay();
      expect(notifier.state.selectedDate.day, initialDate.day);

      notifier.goToToday();
      expect(notifier.state.isSelectedDateToday, true);
    });

    test('Quick add calories creates log correctly', () {
      final beforeCount = notifier.state.currentDateLogs.length;
      notifier.quickAddCalories(
        mealType: 'Snack',
        calories: 180.0,
        protein: 10.0,
        name: 'Quick Protein Shake',
      );

      expect(notifier.state.currentDateLogs.length, beforeCount + 1);
      final lastLog = notifier.state.currentDateLogs.last;
      expect(lastLog.foodName, 'Quick Protein Shake');
      expect(lastLog.caloriesConsumed, 180.0);
      expect(lastLog.mealType, 'Snack');
    });
  });

  group('UserProfile calculations', () {
    test('Calculates BMR and TDEE accurately', () {
      const profile = UserProfile(
        gender: Gender.male,
        age: 25,
        weightKg: 80.0,
        heightCm: 180.0,
        activityLevel: ActivityLevel.moderatelyActive, // 1.55x
        fitnessGoal: FitnessGoal.weightLoss, // -500
      );

      // Mifflin-St Jeor for Male: 10*80 + 6.25*180 - 5*25 + 5 = 800 + 1125 - 125 + 5 = 1805
      expect(profile.bmr, 1805.0);

      // TDEE = 1805 * 1.55 = 2797.75
      expect(profile.tdee, closeTo(2797.75, 0.1));

      // Recommended deficit: 2797.75 - 500 = 2297.75
      expect(profile.recommendedCalories, closeTo(2297.75, 0.1));
    });
  });

  group('MockFoodRepository tests', () {
    test('Supports searching and category filtering', () {
      final repo = MockFoodRepository();
      final allFoods = repo.getAllFoods();
      expect(allFoods.length, greaterThanOrEqualTo(30));

      final chickenFoods = repo.searchFoods('chicken');
      expect(chickenFoods.isNotEmpty, true);
      expect(chickenFoods.first.name.toLowerCase().contains('chicken'), true);

      final proteinOnly = repo.searchFoods('', category: 'Proteins');
      expect(proteinOnly.every((f) => f.category == 'Proteins'), true);
    });

    test('Allows adding custom foods', () {
      final repo = MockFoodRepository();
      const custom = FoodItem(
        id: 'test_custom',
        name: 'Homemade Banana Bread',
        category: 'Snacks',
        baseCalories: 280.0,
        protein: 4.0,
        carbs: 45.0,
        fats: 9.0,
      );

      repo.addCustomFood(custom);
      final found = repo.searchFoods('Banana Bread');
      expect(found.isNotEmpty, true);
      expect(found.first.isCustom, true);
    });
  });
}
