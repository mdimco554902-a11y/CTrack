import '../models/food_item.dart';

class MockFoodRepository {
  static final List<FoodItem> _initialFoods = [
    // PROTEINS
    const FoodItem(
      id: 'food_1',
      name: 'Chicken Breast (Grilled)',
      category: 'Proteins',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 165.0,
      protein: 31.0,
      carbs: 0.0,
      fats: 3.6,
    ),
    const FoodItem(
      id: 'food_2',
      name: 'Whole Egg (Boiled)',
      category: 'Proteins',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 155.0,
      protein: 13.0,
      carbs: 1.1,
      fats: 11.0,
    ),
    const FoodItem(
      id: 'food_3',
      name: 'Egg Whites (Cooked)',
      category: 'Proteins',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 52.0,
      protein: 11.0,
      carbs: 0.7,
      fats: 0.2,
    ),
    const FoodItem(
      id: 'food_4',
      name: 'Salmon Fillet',
      category: 'Proteins',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 208.0,
      protein: 20.4,
      carbs: 0.0,
      fats: 13.4,
    ),
    const FoodItem(
      id: 'food_5',
      name: 'Sirloin Beef Steak (Lean)',
      category: 'Proteins',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 214.0,
      protein: 26.1,
      carbs: 0.0,
      fats: 11.8,
    ),
    const FoodItem(
      id: 'food_6',
      name: 'Tuna (Canned in Water)',
      category: 'Proteins',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 116.0,
      protein: 25.5,
      carbs: 0.0,
      fats: 0.8,
    ),
    const FoodItem(
      id: 'food_7',
      name: 'Extra Firm Tofu',
      category: 'Proteins',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 83.0,
      protein: 10.0,
      carbs: 1.2,
      fats: 5.3,
    ),
    const FoodItem(
      id: 'food_8',
      name: 'Whey Protein Powder',
      category: 'Proteins',
      baseServing: 30.0,
      unit: 'g',
      baseCalories: 120.0,
      protein: 24.0,
      carbs: 2.0,
      fats: 1.5,
    ),
    const FoodItem(
      id: 'food_9',
      name: 'Ground Turkey (93/7)',
      category: 'Proteins',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 150.0,
      protein: 22.0,
      carbs: 0.0,
      fats: 7.0,
    ),
    const FoodItem(
      id: 'food_10',
      name: 'Plain Non-fat Greek Yogurt',
      category: 'Proteins',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 59.0,
      protein: 10.0,
      carbs: 3.6,
      fats: 0.4,
    ),

    // CARBS
    const FoodItem(
      id: 'food_11',
      name: 'White Rice (Cooked)',
      category: 'Carbs',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 130.0,
      protein: 2.7,
      carbs: 28.2,
      fats: 0.3,
    ),
    const FoodItem(
      id: 'food_12',
      name: 'Brown Rice (Cooked)',
      category: 'Carbs',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 123.0,
      protein: 2.7,
      carbs: 25.6,
      fats: 1.0,
    ),
    const FoodItem(
      id: 'food_13',
      name: 'Rolled Oats',
      category: 'Carbs',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 389.0,
      protein: 16.9,
      carbs: 66.3,
      fats: 6.9,
    ),
    const FoodItem(
      id: 'food_14',
      name: 'Sweet Potato (Baked)',
      category: 'Carbs',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 90.0,
      protein: 2.0,
      carbs: 20.7,
      fats: 0.1,
    ),
    const FoodItem(
      id: 'food_15',
      name: 'Whole Wheat Bread',
      category: 'Carbs',
      baseServing: 50.0,
      unit: 'g',
      baseCalories: 125.0,
      protein: 5.5,
      carbs: 23.0,
      fats: 1.8,
    ),
    const FoodItem(
      id: 'food_16',
      name: 'Cooked Pasta',
      category: 'Carbs',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 158.0,
      protein: 5.8,
      carbs: 30.9,
      fats: 0.9,
    ),
    const FoodItem(
      id: 'food_17',
      name: 'Cooked Quinoa',
      category: 'Carbs',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 120.0,
      protein: 4.4,
      carbs: 21.3,
      fats: 1.9,
    ),
    const FoodItem(
      id: 'food_18',
      name: 'Corn Tortilla',
      category: 'Carbs',
      baseServing: 50.0,
      unit: 'g',
      baseCalories: 109.0,
      protein: 2.8,
      carbs: 22.0,
      fats: 1.4,
    ),

    // FATS & DAIRY
    const FoodItem(
      id: 'food_19',
      name: 'Olive Oil',
      category: 'Fats & Dairy',
      baseServing: 15.0,
      unit: 'g',
      baseCalories: 124.0,
      protein: 0.0,
      carbs: 0.0,
      fats: 14.0,
    ),
    const FoodItem(
      id: 'food_20',
      name: 'Peanut Butter',
      category: 'Fats & Dairy',
      baseServing: 32.0,
      unit: 'g',
      baseCalories: 188.0,
      protein: 8.0,
      carbs: 6.0,
      fats: 16.0,
    ),
    const FoodItem(
      id: 'food_21',
      name: 'Avocado (Fresh)',
      category: 'Fats & Dairy',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 160.0,
      protein: 2.0,
      carbs: 8.5,
      fats: 14.7,
    ),
    const FoodItem(
      id: 'food_22',
      name: 'Almonds (Raw)',
      category: 'Fats & Dairy',
      baseServing: 30.0,
      unit: 'g',
      baseCalories: 173.0,
      protein: 6.4,
      carbs: 6.1,
      fats: 15.0,
    ),
    const FoodItem(
      id: 'food_23',
      name: 'Whole Milk (3.25%)',
      category: 'Fats & Dairy',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 62.0,
      protein: 3.2,
      carbs: 4.8,
      fats: 3.3,
    ),
    const FoodItem(
      id: 'food_24',
      name: 'Cheddar Cheese',
      category: 'Fats & Dairy',
      baseServing: 30.0,
      unit: 'g',
      baseCalories: 121.0,
      protein: 7.0,
      carbs: 0.5,
      fats: 10.0,
    ),

    // FRUITS & VEGGIES
    const FoodItem(
      id: 'food_25',
      name: 'Banana (Medium)',
      category: 'Fruits & Veggies',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 89.0,
      protein: 1.1,
      carbs: 22.8,
      fats: 0.3,
    ),
    const FoodItem(
      id: 'food_26',
      name: 'Apple (Gala)',
      category: 'Fruits & Veggies',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 52.0,
      protein: 0.3,
      carbs: 13.8,
      fats: 0.2,
    ),
    const FoodItem(
      id: 'food_27',
      name: 'Steamed Broccoli',
      category: 'Fruits & Veggies',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 35.0,
      protein: 2.4,
      carbs: 7.2,
      fats: 0.4,
    ),
    const FoodItem(
      id: 'food_28',
      name: 'Fresh Baby Spinach',
      category: 'Fruits & Veggies',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 23.0,
      protein: 2.9,
      carbs: 3.6,
      fats: 0.4,
    ),
    const FoodItem(
      id: 'food_29',
      name: 'Blueberries (Fresh)',
      category: 'Fruits & Veggies',
      baseServing: 100.0,
      unit: 'g',
      baseCalories: 57.0,
      protein: 0.7,
      carbs: 14.5,
      fats: 0.3,
    ),

    // SNACKS
    const FoodItem(
      id: 'food_30',
      name: 'Dark Chocolate (70%)',
      category: 'Snacks',
      baseServing: 30.0,
      unit: 'g',
      baseCalories: 170.0,
      protein: 2.3,
      carbs: 13.5,
      fats: 12.0,
    ),
    const FoodItem(
      id: 'food_31',
      name: 'Crispy Rice Cakes',
      category: 'Snacks',
      baseServing: 20.0,
      unit: 'g',
      baseCalories: 77.0,
      protein: 1.6,
      carbs: 16.4,
      fats: 0.6,
    ),
    const FoodItem(
      id: 'food_32',
      name: 'Classic Hummus Dip',
      category: 'Snacks',
      baseServing: 50.0,
      unit: 'g',
      baseCalories: 83.0,
      protein: 2.4,
      carbs: 7.1,
      fats: 4.8,
    ),
  ];

  final List<FoodItem> _customFoods = [];

  List<FoodItem> getAllFoods() {
    return [..._customFoods, ..._initialFoods];
  }

  List<FoodItem> searchFoods(String query, {String? category}) {
    var list = getAllFoods();

    if (category != null && category.isNotEmpty && category != 'All') {
      list = list
          .where((f) => f.category.toLowerCase() == category.toLowerCase())
          .toList();
    }

    if (query.trim().isEmpty) {
      return list;
    }

    final lowercase = query.toLowerCase().trim();
    return list
        .where((item) => item.name.toLowerCase().contains(lowercase))
        .toList();
  }

  void addCustomFood(FoodItem food) {
    _customFoods.insert(0, food.copyWith(isCustom: true));
  }

  void deleteCustomFood(String id) {
    _customFoods.removeWhere((food) => food.id == id);
  }

  FoodItem? getFoodById(String id) {
    try {
      return getAllFoods().firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}
