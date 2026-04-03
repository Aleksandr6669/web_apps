import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../models/recipe.dart';
import '../../styles/app_styles.dart';
import '../../services/recipe_service.dart';
import 'add_recipe_screen.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final _searchController = TextEditingController();
  final RecipeService _recipeService = RecipeService();
  
  late Future<List<Recipe>> _recipesFuture;
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _recipesFuture = _loadRecipes();
    _searchController.addListener(_filterRecipes);
  }

  Future<List<Recipe>> _loadRecipes() async {
    final recipes = await _recipeService.loadRecipes();
    setState(() {
      _allRecipes = recipes;
      _filteredRecipes = recipes;
    });
    return recipes;
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
        // TODO: Сохранить обновленный список в JSON
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
          // TODO: Сохранить обновленный список в JSON
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
      body: FutureBuilder<List<Recipe>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return _buildEmptyState(isInitial: true);
          }

          return _filteredRecipes.isEmpty 
              ? _buildEmptyState(isInitial: _searchController.text.isEmpty) 
              : _buildRecipesList();
        },
      ),
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

  Widget _buildEmptyState({bool isInitial = false}) {
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
            isSearching 
              ? 'Попробуйте изменить запрос' 
              : 'Нажмите +, чтобы добавить свой первый рецепт',
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
        onTap: onTap, 
        hoverColor: Colors.transparent, 
        splashColor: theme.colorScheme.primary.withAlpha(26), // 10% opacity
        contentPadding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withAlpha(26), // 10% opacity
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
          icon: const Icon(Symbols.edit),
          onPressed: onEdit,
          tooltip: 'Редактировать',
        ),
      ),
    );
  }
}
