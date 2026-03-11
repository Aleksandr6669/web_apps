import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../widgets/circular_progress.dart';
import '../../widgets/macronutrient_card.dart';
import '../../widgets/meal_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Symbols.calendar_today, color: Color(0xFF00C753)),
        ),
        title: const Text('Сегодня'),
        actions: [
          IconButton(
            icon: const Icon(Symbols.notifications, color: Color(0xFF00C753)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Symbols.search, color: Color(0xFF00C753)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Main Progress Section
              Card(
                elevation: 4,
                shadowColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgress(
                              progress: 0.67, // 1420 / 2100
                              size: 200,
                              strokeWidth: 16,
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                              progressColor: theme.colorScheme.primary,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('1 420', style: theme.textTheme.displaySmall),
                                Text('ОСТАЛОСЬ ККАЛ', style: theme.textTheme.bodySmall),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(theme, Symbols.restaurant, '840', 'ЕДА'),
                          _buildStatItem(theme, Symbols.fitness_center, '160', 'УПР-ИЯ', color: Colors.orange),
                          _buildStatItem(theme, Symbols.flag, '2 100', 'ЦЕЛЬ', color: Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Macronutrients
              const Row(
                children: [
                  Expanded(
                    child: MacronutrientCard(
                      name: 'Углеводы',
                      value: '120г',
                      total: '250г',
                      percentage: 0.48,
                      color: Color(0xFF00C753),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: MacronutrientCard(
                      name: 'Белки',
                      value: '60г',
                      total: '150г',
                      percentage: 0.4,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: MacronutrientCard(
                      name: 'Жиры',
                      value: '45г',
                      total: '70г',
                      percentage: 0.64,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Meals Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Приемы пищи', style: theme.textTheme.headlineSmall),
                  TextButton(
                    onPressed: () {},
                    child: Text('История', style: TextStyle(color: theme.colorScheme.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const MealCard(
                name: 'Завтрак',
                recommendedCalories: 'Рекомендовано: 450 - 600 ккал',
                calories: '320',
                icon: Symbols.wb_sunny,
                iconColor: Colors.orange,
                iconBackgroundColor: Color(0xFFFFF4E6),
                isConsumed: true,
              ),
              const MealCard(
                name: 'Обед',
                recommendedCalories: 'Рекомендовано: 600 - 800 ккал',
                calories: '520',
                icon: Symbols.lunch_dining,
                iconColor: Color(0xFF00C753),
                iconBackgroundColor: Color(0xFFE6F9F0),
                isConsumed: true,
              ),
              const MealCard(
                name: 'Ужин',
                recommendedCalories: 'Рекомендовано: 450 - 600 ккал',
                calories: '0',
                icon: Symbols.nights_stay,
                iconColor: Colors.indigo,
                iconBackgroundColor: Color(0xFFEEF2FF),
              ),
              const MealCard(
                name: 'Перекус',
                recommendedCalories: 'Рекомендовано: 150 - 250 ккал',
                calories: '0',
                icon: Symbols.cookie,
                iconColor: Colors.pink,
                iconBackgroundColor: Color(0xFFFCE7F3),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Symbols.menu_book, fill: 1),
            label: 'Дневник',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.receipt_long),
            label: 'Рецепты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.analytics),
            label: 'Анализ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, IconData icon, String value, String label, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleLarge),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
