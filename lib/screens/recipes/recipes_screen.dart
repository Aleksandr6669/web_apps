import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../models/recipe.dart';
import '../../models/food_item.dart';
import '../../styles/app_styles.dart';
import '../../styles/app_colors.dart'; // Импортируем цвета
import 'add_recipe_screen.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final _searchController = TextEditingController();
  late List<Recipe> _filteredRecipes;

  final List<Recipe> _allRecipes = [
    Recipe(
      name: 'Овсянка с фруктами',
      description: 'Полезный и сытный завтрак',
      icon: Symbols.breakfast_dining,
      nutrients: NutritionalInfo(calories: 350, protein: 10, carbs: 60, fat: 8),
    ),
    Recipe(
      name: 'Куриная грудка на гриле',
      description: 'С овощами и киноа',
      icon: Symbols.lunch_dining,
      nutrients: NutritionalInfo(calories: 450, protein: 50, carbs: 30, fat: 15),
    ),
    Recipe(
      name: 'Салат Цезарь',
      description: 'Классический рецепт с курицей',
      icon: Symbols.ramen_dining,
      nutrients: NutritionalInfo(calories: 400, protein: 30, carbs: 15, fat: 25),
    ),
    Recipe(
      name: 'Смузи "Зеленый детокс"',
      description: 'Шпинат, яблоко, банан, вода',
      icon: Symbols.local_bar,
      nutrients: NutritionalInfo(calories: 150, protein: 5, carbs: 35, fat: 1),
    ),
    Recipe(
      name: 'Лосось запеченный',
      description: 'С лимоном и травами',
      icon: Symbols.set_meal,
      nutrients: NutritionalInfo(calories: 550, protein: 45, carbs: 5, fat: 40),
    ),
    Recipe(
      name: 'Греческий салат',
      description: 'Свежие овощи и фета',
      icon: Symbols.restaurant,
      nutrients: NutritionalInfo(calories: 300, protein: 8, carbs: 10, fat: 25),
    ),
    Recipe(
      name: 'Паста Карбонара',
      description: 'Сливочный соус и бекон',
      icon: Symbols.dinner_dining,
      nutrients: NutritionalInfo(calories: 600, protein: 25, carbs: 70, fat: 28),
    ),
    Recipe(
      name: 'Протеиновый коктейль',
      description: 'После тренировки',
      icon: Symbols.blender,
      nutrients: NutritionalInfo(calories: 250, protein: 30, carbs: 20, fat: 5),
    ),
    Recipe(
      name: 'Чечевичный суп',
      description: 'Насыщенный и ароматный',
      icon: Symbols.soup_kitchen,
      nutrients: NutritionalInfo(calories: 320, protein: 18, carbs: 55, fat: 4),
    ),
    Recipe(
      name: 'Творожная запеканка',
      description: 'С изюмом и сметаной',
      icon: Symbols.cake,
      nutrients: NutritionalInfo(calories: 280, protein: 20, carbs: 25, fat: 12),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredRecipes = _allRecipes;
    _searchController.addListener(_filterRecipes);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterRecipes);
    _searchController.dispose();
    super.dispose();
  }

  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes = _allRecipes.where((recipe) {
        return recipe.name.toLowerCase().contains(query) ||
               recipe.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addRecipe() async {
    final newRecipe = await Navigator.of(context).push<Recipe>(
      MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
    );
    if (newRecipe != null) {
      setState(() {
        _allRecipes.insert(0, newRecipe);
        _filterRecipes();
      });
    }
  }

  void _editRecipe(Recipe recipeToEdit) async {
    final updatedRecipe = await Navigator.of(context).push<Recipe>(
      MaterialPageRoute(
        builder: (context) => AddRecipeScreen(recipeToEdit: recipeToEdit),
      ),
    );

    if (updatedRecipe != null) {
      setState(() {
        final originalIndex = _allRecipes.indexWhere((r) => r.name == recipeToEdit.name); 
        if (originalIndex != -1) {
          _allRecipes[originalIndex] = updatedRecipe;
          _filterRecipes();
        }
      });
    }
  }

  void _navigateToDetail(Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои рецепты'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Найти рецепт...',
                prefixIcon: const Icon(Symbols.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: AppStyles.defaultBorderRadius,
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Symbols.add_circle_outline),
            onPressed: _addRecipe,
            tooltip: 'Добавить рецепт',
          ),
        ],
      ),
      body: _filteredRecipes.isEmpty ? _buildEmptyState() : _buildRecipesList(),
    );
  }

  Widget _buildRecipesList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = _filteredRecipes[index];
        return _RecipeListItem(
          recipe: recipe,
          onTap: () => _navigateToDetail(recipe),
          onEdit: () => _editRecipe(recipe),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final isSearching = _searchController.text.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Symbols.search_off : Symbols.receipt_long,
            size: 80,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          const SizedBox(height: 24),
          Text(
            isSearching ? 'Ничего не найдено' : 'У вас пока нет рецептов',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            isSearching ? 'Попробуйте изменить запрос' : 'Нажмите +, чтобы добавить свой первый рецепт',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _RecipeListItem({
    required this.recipe,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        hoverColor: Colors.transparent, 
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        contentPadding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Icon(
            recipe.icon,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(recipe.name, style: theme.textTheme.titleMedium),
        subtitle: recipe.description.isNotEmpty
            ? Text(
                recipe.description,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Symbols.edit, color: AppColors.primary), // <--- ИЗМЕНЕНИЕ ЦВЕТА
          onPressed: onEdit,
          tooltip: 'Редактировать',
        ),
        onTap: onTap,
      ),
    );
  }
}
