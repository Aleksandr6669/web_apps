import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_profile.dart';

class ProfileService {
  Future<UserProfile> loadProfile() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/profile.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return UserProfile.fromJson(jsonMap);
    } catch (e) {
      // Если что-то пошло не так, возвращаем профиль по умолчанию
      return UserProfile.fromJson(const {}); // Пустой JSON для создания профиля по умолчанию
    }
  }

  // TODO: Добавить метод для сохранения профиля
  // Future<void> saveProfile(UserProfile profile) async { ... }
}
