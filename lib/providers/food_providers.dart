import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/food_item.dart';
import '../repositories/mock_food_repository.dart';

final foodRepositoryProvider = Provider<MockFoodRepository>((ref) {
  return MockFoodRepository();
});

final foodSearchQueryProvider = StateProvider<String>((ref) => '');

final foodSelectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Version counter to trigger re-reads when custom foods are added
final foodListRevisionProvider = StateProvider<int>((ref) => 0);

final filteredFoodsProvider = Provider<List<FoodItem>>((ref) {
  final repository = ref.watch(foodRepositoryProvider);
  final query = ref.watch(foodSearchQueryProvider);
  final category = ref.watch(foodSelectedCategoryProvider);
  ref.watch(foodListRevisionProvider);

  return repository.searchFoods(query, category: category);
});
