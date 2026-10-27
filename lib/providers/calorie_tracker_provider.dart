import 'package:flutter_riverpod/legacy.dart';
import '../models/daily_log.dart';

class CalorieTrackerState {
  final DateTime selectedDate;
  final double dailyCalorieGoal;
  final double proteinGoal;
  final double carbsGoal;
  final double fatsGoal;
  final List<DailyLog> logs;

  CalorieTrackerState({
    DateTime? selectedDate,
    this.dailyCalorieGoal = 2200.0,
    this.proteinGoal = 150.0,
    this.carbsGoal = 230.0,
    this.fatsGoal = 65.0,
    this.logs = const [],
  }) : selectedDate = selectedDate ?? DateTime.now();

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool get isSelectedDateToday {
    return isSameDay(selectedDate, DateTime.now());
  }

  /// All logs matching the currently active date
  List<DailyLog> get currentDateLogs {
    return logs.where((l) => isSameDay(l.loggedAt, selectedDate)).toList();
  }

  double get totalCaloriesConsumed =>
      currentDateLogs.fold(0.0, (sum, log) => sum + log.caloriesConsumed);

  double get remainingCalories {
    final remaining = dailyCalorieGoal - totalCaloriesConsumed;
    return remaining > 0 ? remaining : 0;
  }

  bool get isOverBudget => totalCaloriesConsumed > dailyCalorieGoal;

  double get caloriesOverBudget =>
      isOverBudget ? (totalCaloriesConsumed - dailyCalorieGoal) : 0.0;

  double get calorieProgress {
    if (dailyCalorieGoal <= 0) return 0.0;
    final progress = totalCaloriesConsumed / dailyCalorieGoal;
    return progress.clamp(0.0, 1.0);
  }

  double get totalProtein =>
      currentDateLogs.fold(0.0, (sum, log) => sum + log.protein);

  double get totalCarbs =>
      currentDateLogs.fold(0.0, (sum, log) => sum + log.carbs);

  double get totalFats =>
      currentDateLogs.fold(0.0, (sum, log) => sum + log.fats);

  List<DailyLog> getLogsByMealType(String mealType) {
    return currentDateLogs
        .where((log) => log.mealType.toLowerCase() == mealType.toLowerCase())
        .toList();
  }

  CalorieTrackerState copyWith({
    DateTime? selectedDate,
    double? dailyCalorieGoal,
    double? proteinGoal,
    double? carbsGoal,
    double? fatsGoal,
    List<DailyLog>? logs,
  }) {
    return CalorieTrackerState(
      selectedDate: selectedDate ?? this.selectedDate,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      carbsGoal: carbsGoal ?? this.carbsGoal,
      fatsGoal: fatsGoal ?? this.fatsGoal,
      logs: logs ?? this.logs,
    );
  }
}

class CalorieTrackerNotifier extends StateNotifier<CalorieTrackerState> {
  CalorieTrackerNotifier() : super(CalorieTrackerState()) {
    _initSeedLogs();
  }

  void _initSeedLogs() {
    final now = DateTime.now();
    state = state.copyWith(
      dailyCalorieGoal: 2200.0,
      proteinGoal: 150.0,
      carbsGoal: 230.0,
      fatsGoal: 65.0,
      logs: [
        DailyLog(
          id: 'log_seed_1',
          foodName: 'Rolled Oats',
          caloriesConsumed: 389.0,
          mealType: 'Breakfast',
          servingGrams: 100.0,
          protein: 16.9,
          carbs: 66.3,
          fats: 6.9,
          loggedAt: now,
        ),
        DailyLog(
          id: 'log_seed_2',
          foodName: 'Whole Egg (Boiled)',
          caloriesConsumed: 155.0,
          mealType: 'Breakfast',
          servingGrams: 100.0,
          protein: 13.0,
          carbs: 1.1,
          fats: 11.0,
          loggedAt: now,
        ),
        DailyLog(
          id: 'log_seed_3',
          foodName: 'Chicken Breast (Grilled)',
          caloriesConsumed: 330.0,
          mealType: 'Lunch',
          servingGrams: 200.0,
          protein: 62.0,
          carbs: 0.0,
          fats: 7.2,
          loggedAt: now,
        ),
        DailyLog(
          id: 'log_seed_4',
          foodName: 'White Rice (Cooked)',
          caloriesConsumed: 260.0,
          mealType: 'Lunch',
          servingGrams: 200.0,
          protein: 5.4,
          carbs: 56.4,
          fats: 0.6,
          loggedAt: now,
        ),
      ],
    );
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void goToPreviousDay() {
    final prev = state.selectedDate.subtract(const Duration(days: 1));
    state = state.copyWith(selectedDate: prev);
  }

  void goToNextDay() {
    final next = state.selectedDate.add(const Duration(days: 1));
    state = state.copyWith(selectedDate: next);
  }

  void goToToday() {
    state = state.copyWith(selectedDate: DateTime.now());
  }

  void addLog(DailyLog log) {
    state = state.copyWith(logs: [...state.logs, log]);
  }

  void updateLog(DailyLog updatedLog) {
    state = state.copyWith(
      logs: state.logs.map((log) {
        return log.id == updatedLog.id ? updatedLog : log;
      }).toList(),
    );
  }

  void removeLog(String logId) {
    state = state.copyWith(
      logs: state.logs.where((l) => l.id != logId).toList(),
    );
  }

  void quickAddCalories({
    required String mealType,
    required double calories,
    double protein = 0.0,
    double carbs = 0.0,
    double fats = 0.0,
    String name = 'Quick Calorie Add',
  }) {
    final newLog = DailyLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      foodName: name,
      caloriesConsumed: calories,
      mealType: mealType,
      servingGrams: 100.0,
      protein: protein,
      carbs: carbs,
      fats: fats,
      loggedAt: state.selectedDate,
    );
    addLog(newLog);
  }

  void updateDailyGoal(double newGoal) {
    if (newGoal > 0) {
      state = state.copyWith(dailyCalorieGoal: newGoal);
    }
  }

  void updateMacroGoals({
    double? protein,
    double? carbs,
    double? fats,
  }) {
    state = state.copyWith(
      proteinGoal: protein ?? state.proteinGoal,
      carbsGoal: carbs ?? state.carbsGoal,
      fatsGoal: fats ?? state.fatsGoal,
    );
  }

  void resetLogsForDate(DateTime date) {
    state = state.copyWith(
      logs: state.logs
          .where((l) => !CalorieTrackerState.isSameDay(l.loggedAt, date))
          .toList(),
    );
  }

  void loadDemoData() {
    _initSeedLogs();
  }

  void clearAllLogs() {
    state = state.copyWith(logs: []);
  }
}

final calorieTrackerProvider =
    StateNotifierProvider<CalorieTrackerNotifier, CalorieTrackerState>((ref) {
  return CalorieTrackerNotifier();
});
