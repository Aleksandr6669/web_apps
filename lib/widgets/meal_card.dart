import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MealCard extends StatelessWidget {
  final String name;
  final String recommendedCalories;
  final String calories;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final bool isConsumed;

  const MealCard({
    super.key,
    required this.name,
    required this.recommendedCalories,
    required this.calories,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.isConsumed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleMedium),
                    Text(recommendedCalories, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '$calories ккал',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isConsumed ? Theme.of(context).textTheme.titleMedium?.color : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    backgroundColor: const Color(0xFF00C753),
                  ),
                  child: const Icon(Symbols.add, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
