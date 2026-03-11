import 'package:flutter/material.dart';

enum MealType {
  breakfast,
  lunch,
  dinner,
  snack,
}

class FoodEntry {
  final String id;
  final MealType mealType;
  final String name;
  final int calories;
  final int protein;
  final int fat;
  final int carbs;
  final int grams;
  final DateTime timestamp;

  FoodEntry({
    required this.id,
    required this.mealType,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.grams,
    required this.timestamp,
  });

  static String mealTypeToString(MealType mealType, BuildContext context) {
    switch (mealType) {
      case MealType.breakfast:
        return 'Завтрак';
      case MealType.lunch:
        return 'Обед';
      case MealType.dinner:
        return 'Ужин';
      case MealType.snack:
        return 'Перекус';
    }
  }
}
