import 'package:flutter/material.dart';
import 'food_item.dart';

class Recipe {
  final String name;
  final String description;
  final IconData icon;
  final NutritionalInfo nutrients;

  Recipe({
    required this.name,
    required this.description,
    required this.icon,
    required this.nutrients,
  });
}
