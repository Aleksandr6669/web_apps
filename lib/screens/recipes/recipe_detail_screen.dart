import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../models/recipe.dart';
import '../../models/food_item.dart';
import '../../styles/app_styles.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nutrients = recipe.nutrients;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            // TODO: Implement adding recipe to a meal
            icon: const Icon(Symbols.add_shopping_cart),
            onPressed: () {},
            tooltip: 'Добавить в прием пищи',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            Text('Пищевая ценность (на порцию)', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildNutritionalDetails(theme, nutrients),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppStyles.largeBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primary.withAlpha(26), // 10% opacity
                child: Icon(recipe.icon, size: 40, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text(recipe.name, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
              if (recipe.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    recipe.description,
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodySmall?.color),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionalDetails(ThemeData theme, NutritionalInfo nutrients) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppStyles.largeBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow(theme, 'Калории', '${nutrients.calories} ккал'),
            _buildDivider(),
            _buildDetailRow(theme, 'Белки', '${nutrients.protein.toStringAsFixed(1)} г'),
            _buildDetailRow(theme, 'Углеводы', '${nutrients.carbs.toStringAsFixed(1)} г'),
            _buildDetailRow(theme, '   в т.ч. Сахар', '${nutrients.sugar.toStringAsFixed(1)} г', isSub: true),
            _buildDetailRow(theme, '   в т.ч. Клетчатка', '${nutrients.fiber.toStringAsFixed(1)} г', isSub: true),
            _buildDivider(),
            _buildDetailRow(theme, 'Жиры', '${nutrients.fat.toStringAsFixed(1)} г'),
            _buildDetailRow(theme, '   Насыщенные', '${nutrients.saturatedFat.toStringAsFixed(1)} г', isSub: true),
            _buildDetailRow(theme, '   Полиненасыщенные', '${nutrients.polyunsaturatedFat.toStringAsFixed(1)} г', isSub: true),
            _buildDetailRow(theme, '   Мононенасыщенные', '${nutrients.monounsaturatedFat.toStringAsFixed(1)} г', isSub: true),
            _buildDetailRow(theme, '   Трансжиры', '${nutrients.transFat.toStringAsFixed(1)} г', isSub: true),
             if (nutrients.cholesterol > 0 || nutrients.sodium > 0) ...[
                _buildDivider(),
                if (nutrients.cholesterol > 0) _buildDetailRow(theme, 'Холестерин', '${nutrients.cholesterol.toStringAsFixed(0)} мг'),
                if (nutrients.sodium > 0) _buildDetailRow(theme, 'Натрий', '${nutrients.sodium.toStringAsFixed(0)} мг'),
             ],
             if (nutrients.vitaminA > 0 || nutrients.vitaminC > 0 || nutrients.calcium > 0 || nutrients.iron > 0) ...[
                _buildDivider(),
                if (nutrients.vitaminA > 0) _buildDetailRow(theme, 'Витамин A', '${nutrients.vitaminA}%'),
                if (nutrients.vitaminC > 0) _buildDetailRow(theme, 'Витамин C', '${nutrients.vitaminC}%'),
                if (nutrients.calcium > 0) _buildDetailRow(theme, 'Кальций', '${nutrients.calcium}%'),
                if (nutrients.iron > 0) _buildDetailRow(theme, 'Железо', '${nutrients.iron}%'),
             ]
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value, {bool isSub = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isSub ? theme.textTheme.bodyMedium : theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(height: 1),
    );
  }
}
