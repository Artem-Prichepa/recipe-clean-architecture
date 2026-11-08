import 'package:flutter/material.dart';
import 'package:lab_layout/application/use_cases/add_note_use_case.dart';
import 'package:lab_layout/application/use_cases/delete_note_use_case.dart';
import 'package:lab_layout/application/use_cases/get_recipe_use_case.dart';
import 'package:lab_layout/application/use_cases/scale_ingredients_use_case.dart';
import 'package:lab_layout/application/use_cases/toggle_favorite_use_case.dart';
import 'package:lab_layout/infrastructure/repositories/in_memory_favorites_repository.dart';
import 'package:lab_layout/infrastructure/repositories/in_memory_notes_repository.dart';
import 'package:lab_layout/infrastructure/repositories/in_memory_recipe_repository.dart';
import 'package:lab_layout/presentation/notifiers/notes_notifier.dart';
import 'package:lab_layout/presentation/notifiers/recipe_notifier.dart';
import 'package:provider/provider.dart';
import 'package:lab_layout/presentation/screens/home_screen.dart';

void main() {
  runApp(createApp());
}

/// Composition root: ручне впровадження залежностей (Dependency Injection).
/// Репозиторії (Infrastructure) → use cases (Application) → нотифікатори (Presentation).
Widget createApp() {
  // Infrastructure
  final recipeRepository = InMemoryRecipeRepository();
  final favoritesRepository = InMemoryFavoritesRepository();
  final notesRepository = InMemoryNotesRepository();

  // Application
  final getRecipe = GetRecipeUseCase(recipeRepository);
  final scaleIngredients = ScaleIngredientsUseCase();
  final toggleFavorite = ToggleFavoriteUseCase(favoritesRepository);
  final addNote = AddNoteUseCase(notesRepository);
  final deleteNote = DeleteNoteUseCase(notesRepository);

  // Presentation
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => RecipeNotifier(
          getRecipe: getRecipe,
          scaleIngredients: scaleIngredients,
          toggleFavorite: toggleFavorite,
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => NotesNotifier(addNote: addNote, deleteNote: deleteNote),
      ),
    ],
    child: const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      title: "MyApp",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF4A261),
          dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
          brightness: Brightness.light,
        ),
      ),
    );
  }
}
