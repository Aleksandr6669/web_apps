import 'food_item.dart';

class DailyLog {
  final DateTime date;
  final int waterIntake; // в миллилитрах
  final int activityCalories;
  final int steps;
  final double? weight;
  final Map<String, List<FoodItem>> meals; // e.g., {'Завтрак': [FoodItem, ...]}

  DailyLog({
    required this.date,
    required this.waterIntake,
    required this.activityCalories,
    required this.steps,
    this.weight,
    required this.meals,
  });

  // Проверяем, были ли за день записаны какие-либо данные
  bool get isEmpty {
    final bool noMeals = meals.values.every((list) => list.isEmpty);
    return noMeals && waterIntake == 0 && activityCalories == 0 && steps == 0 && weight == null;
  }

  // Пустой лог для дня, в котором еще нет записей
  factory DailyLog.empty(DateTime date) {
    return DailyLog(
      date: date,
      waterIntake: 0,
      activityCalories: 0,
      steps: 0,
      weight: null,
      meals: {
        'Завтрак': [],
        'Обед': [],
        'Ужин': [],
        'Перекусы': [],
      },
    );
  }

  // Подсчет общих нутриентов за день
  NutritionalInfo get totalNutrients {
    return meals.values.fold<NutritionalInfo>(
      NutritionalInfo.zero,
      (total, foodItems) =>
          total +
          foodItems.fold<NutritionalInfo>(
            NutritionalInfo.zero,
            (mealTotal, item) => mealTotal + item.nutrients,
          ),
    );
  }
}
