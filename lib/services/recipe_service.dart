import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../models/recipe.dart';
import '../models/food_item.dart';

class RecipeService {
  // Маппинг строковых имен иконок в реальные IconData
  static final Map<String, IconData> _iconMapping = {
    'breakfast_dining': Symbols.breakfast_dining,
    'lunch_dining': Symbols.lunch_dining,
    'ramen_dining': Symbols.ramen_dining,
    'local_bar': Symbols.local_bar,
    'set_meal': Symbols.set_meal,
    'restaurant': Symbols.restaurant,
    'dinner_dining': Symbols.dinner_dining,
    'blender': Symbols.blender,
    'soup_kitchen': Symbols.soup_kitchen,
    'cake': Symbols.cake,
    // Добавьте другие иконки по мере необходимости
  };

  static IconData getIcon(String iconName) {
    return _iconMapping[iconName] ?? Symbols.help_outline; // Иконка по умолчанию
  }

  Future<List<Recipe>> loadRecipes() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/recipes.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList.map((json) {
        final nutrientsJson = json['nutrients'];
        return Recipe(
          name: json['name'] ?? '',
          description: json['description'] ?? '',
          icon: getIcon(json['icon'] ?? ''),
          nutrients: NutritionalInfo(
            calories: (nutrientsJson['calories'] as num?)?.toDouble() ?? 0.0,
            protein: (nutrientsJson['protein'] as num?)?.toDouble() ?? 0.0,
            carbs: (nutrientsJson['carbs'] as num?)?.toDouble() ?? 0.0,
            fat: (nutrientsJson['fat'] as num?)?.toDouble() ?? 0.0,
          ),
        );
      }).toList();
    } catch (e) {
      // В реальном приложении здесь лучше использовать более надежный логгер
      return [];
    }
  }
}
