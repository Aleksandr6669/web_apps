import 'package:flutter/material.dart';

class NutritionalInfo {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  // Detailed breakdown
  final double saturatedFat;
  final double polyunsaturatedFat;
  final double monounsaturatedFat;
  final double transFat;
  final double cholesterol; // mg
  final double sodium; // mg
  final double potassium; // mg
  final double fiber;
  final double sugar;
  // Vitamins (as a percentage of DV - Daily Value)
  final int vitaminA;
  final int vitaminC;
  final int vitaminD;
  final int calcium; // %
  final int iron; // %

  NutritionalInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.saturatedFat = 0,
    this.polyunsaturatedFat = 0,
    this.monounsaturatedFat = 0,
    this.transFat = 0,
    this.cholesterol = 0,
    this.sodium = 0,
    this.potassium = 0,
    this.fiber = 0,
    this.sugar = 0,
    this.vitaminA = 0,
    this.vitaminC = 0,
    this.vitaminD = 0,
    this.calcium = 0,
    this.iron = 0,
  });

  // Helper to create an empty info object
  static NutritionalInfo get zero => NutritionalInfo(calories: 0, protein: 0, carbs: 0, fat: 0);

  // Helper to add two NutritionalInfo objects together
  NutritionalInfo operator +(NutritionalInfo other) {
    return NutritionalInfo(
      calories: calories + other.calories,
      protein: protein + other.protein,
      carbs: carbs + other.carbs,
      fat: fat + other.fat,
      saturatedFat: saturatedFat + other.saturatedFat,
      polyunsaturatedFat: polyunsaturatedFat + other.polyunsaturatedFat,
      monounsaturatedFat: monounsaturatedFat + other.monounsaturatedFat,
      transFat: transFat + other.transFat,
      cholesterol: cholesterol + other.cholesterol,
      sodium: sodium + other.sodium,
      potassium: potassium + other.potassium,
      fiber: fiber + other.fiber,
      sugar: sugar + other.sugar,
      vitaminA: vitaminA + other.vitaminA,
      vitaminC: vitaminC + other.vitaminC,
      vitaminD: vitaminD + other.vitaminD,
      calcium: calcium + other.calcium,
      iron: iron + other.iron,
    );
  }
}

class FoodItem {
  final IconData icon;
  final String name;
  final String description;
  final NutritionalInfo nutrients;

  FoodItem({
    required this.icon,
    required this.name,
    required this.description,
    required this.nutrients,
  });
}
