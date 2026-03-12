
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../styles/app_styles.dart';

class RecipeForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController caloriesController;
  final TextEditingController proteinController;
  final TextEditingController fatController;
  final TextEditingController carbsController;

  const RecipeForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.caloriesController,
    required this.proteinController,
    required this.fatController,
    required this.carbsController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(context, nameController, 'Название рецепта'),
            const SizedBox(height: 16),
            _buildTextField(context, descriptionController, 'Описание', maxLines: 3),
            const SizedBox(height: 24),
            Text('Пищевая ценность (на 100г)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: AppStyles.defaultBorderRadius),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildNutrientField(caloriesController, 'Калории', 'ккал'),
                    const Divider(height: 24),
                    _buildNutrientField(proteinController, 'Белки', 'г'),
                    const Divider(height: 24),
                    _buildNutrientField(fatController, 'Жиры', 'г'),
                    const Divider(height: 24),
                    _buildNutrientField(carbsController, 'Углеводы', 'г'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller, String label, {int maxLines = 1}) {
    final border = OutlineInputBorder(
      borderRadius: AppStyles.defaultBorderRadius,
      borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.5)),
    );
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Поле не может быть пустым';
        }
        return null;
      },
    );
  }

  Widget _buildNutrientField(TextEditingController controller, String label, String suffix) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: InputBorder.none,
        filled: false,
      ),
       validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Обязательное поле';
        }
        if (double.tryParse(value.replaceAll(',', '.')) == null) {
          return 'Неверный формат';
        }
        return null;
      },
    );
  }
}
