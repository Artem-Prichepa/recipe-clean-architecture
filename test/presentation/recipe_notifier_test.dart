import 'package:flutter_test/flutter_test.dart';
import 'package:lab_layout/application/use_cases/get_favorites_use_case.dart';
import 'package:lab_layout/application/use_cases/get_recipe_use_case.dart';
import 'package:lab_layout/application/use_cases/scale_ingredients_use_case.dart';
import 'package:lab_layout/application/use_cases/toggle_favorite_use_case.dart';
import 'package:lab_layout/domain/entities/ingredient.dart';
import 'package:lab_layout/domain/entities/recipe.dart';
import 'package:lab_layout/presentation/notifiers/recipe_notifier.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRecipeUseCase extends Mock implements GetRecipeUseCase {}

class MockScaleIngredientsUseCase extends Mock
    implements ScaleIngredientsUseCase {}

class MockGetFavoritesUseCase extends Mock implements GetFavoritesUseCase {}

class MockToggleFavoriteUseCase extends Mock implements ToggleFavoriteUseCase {}

const _recipe = Recipe(
  name: 'Борщ',
  baseServings: 2,
  ingredients: [Ingredient('Сіль', 1, 'г')],
  steps: ['Варити'],
);

void main() {
  late MockGetRecipeUseCase getRecipe;
  late MockScaleIngredientsUseCase scale;
  late MockGetFavoritesUseCase getFavorites;
  late MockToggleFavoriteUseCase toggle;
  late int listenerCalls;

  RecipeNotifier createNotifier() {
    final notifier = RecipeNotifier(
      getRecipe: getRecipe,
      scaleIngredients: scale,
      getFavorites: getFavorites,
      toggleFavorite: toggle,
    );
    notifier.addListener(() => listenerCalls++);
    return notifier;
  }

  setUpAll(() {
    registerFallbackValue(_recipe);
  });

  setUp(() {
    getRecipe = MockGetRecipeUseCase();
    scale = MockScaleIngredientsUseCase();
    getFavorites = MockGetFavoritesUseCase();
    toggle = MockToggleFavoriteUseCase();
    listenerCalls = 0;
    when(() => getRecipe()).thenReturn(_recipe);
    when(() => getFavorites()).thenReturn(<String>{});
    when(() => scale(any(), any())).thenReturn(_recipe.ingredients);
  });

  test('початкові порції дорівнюють baseServings, інгредієнти масштабовані', () {
    final notifier = createNotifier();

    expect(notifier.servings, 2);
    verify(() => scale(_recipe, 2)).called(1);
  });

  test('setServings(0) ігнорується і не викликає scale', () {
    final notifier = createNotifier();
    clearInteractions(scale);

    notifier.setServings(0);

    expect(notifier.servings, 2);
    expect(listenerCalls, 0);
    verifyNever(() => scale(any(), any()));
  });

  test('setServings(1) приймається, scale викликається, listener один раз', () {
    final notifier = createNotifier();

    notifier.setServings(1);

    expect(notifier.servings, 1);
    expect(listenerCalls, 1);
    verify(() => scale(_recipe, 1)).called(1);
  });

  test('setServings(12) приймається, scale викликається, listener один раз', () {
    final notifier = createNotifier();

    notifier.setServings(12);

    expect(notifier.servings, 12);
    expect(listenerCalls, 1);
    verify(() => scale(_recipe, 12)).called(1);
  });

  test('setServings(13) ігнорується і не викликає scale', () {
    final notifier = createNotifier();
    clearInteractions(scale);

    notifier.setServings(13);

    expect(notifier.servings, 2);
    expect(listenerCalls, 0);
    verifyNever(() => scale(any(), any()));
  });

  test('toggleFavorite додає страву, isFavorite повертає true', () {
    when(() => toggle('Борщ')).thenReturn({'Борщ'});
    final notifier = createNotifier();

    notifier.toggleFavorite('Борщ');

    expect(notifier.isFavorite('Борщ'), isTrue);
    expect(listenerCalls, 1);
    verify(() => toggle('Борщ')).called(1);
  });

  test('toggleFavorite прибирає страву, isFavorite повертає false', () {
    when(() => getFavorites()).thenReturn({'Борщ'});
    when(() => toggle('Борщ')).thenReturn(<String>{});
    final notifier = createNotifier();

    notifier.toggleFavorite('Борщ');

    expect(notifier.isFavorite('Борщ'), isFalse);
    expect(listenerCalls, 1);
  });
}
