import 'package:flutter/material.dart';
import 'package:lab_layout/models/ingredient.dart';
import 'package:lab_layout/recipeNotifier/recipe_notifier.dart';
import 'package:lab_layout/recipeNotifier/notes_notifier.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // region ingredients counter
  final List<Ingredient> _ingredients = [
    Ingredient("Хліб", 2, "шт"),
    Ingredient("Мазік", 100, "г"),
    Ingredient("Ковбаса", 200, "г"),
    Ingredient("Кептчуп", 100, "г"),
    Ingredient("Сир", 200, "г"),
    Ingredient("Помідор", 1, "шт"),
  ];
  //endregion

  static const String _dishName = 'Student food';
  bool _showIngredients = true;
  bool _showSteps = false;
  final TextEditingController _noteController = TextEditingController();
  final int _baseServings = 2;

  void _onOpenNotes() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Notes"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _noteController,
              decoration: InputDecoration(hintText: "Нова нотатка"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Закрити"),
          ),
          TextButton(
            onPressed: () {
              _onAddNote();
              Navigator.pop(ctx);
            },
            child: Text("Зберегти"),
          ),
        ],
      ),
    );
  }

  void _onAddNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;
    context.read<NotesNotifier>().addNote(text);
    _noteController.clear();
  }

  void _onDeleteNote(String note) {
    context.read<NotesNotifier>().deleteNote(note);
  }

  void _onToggleFavorite() {
    context.read<RecipeNotifier>().toggleFavorite(_dishName);
  }

  void _onIncrementServings() {
    final n = context.read<RecipeNotifier>();
    n.setServings(n.servings + 1);
  }

  void _onDecrementServings() {
    final n = context.read<RecipeNotifier>();
    n.setServings(n.servings - 1);
  }

  void _onShowIngredients() {
    setState(() {
      _showIngredients = true;
      _showSteps = false;
    });
  }

  void _onShowSteps() {
    setState(() {
      _showIngredients = false;
      _showSteps = true;
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isNarrow = MediaQuery.of(context).size.width < 500;
    final colors = Theme.of(context).colorScheme;
    // final texts = Theme.of(context).textTheme;

    return Scaffold(
      //TOP BAR
      appBar: AppBar(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        ),
        toolbarHeight: 50,
        backgroundColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.scrolledUnder)) {
            return colors.secondaryContainer;
          }
          return Colors.transparent;
        }),
        title: isNarrow
            ? Text(
                'Student food',
                style: TextStyle(fontWeight: FontWeight(600)),
              )
            : Text(
                "Назва страви: 'Student food'",
                style: TextStyle(fontWeight: FontWeight(600)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        actions: <Widget>[
          Consumer<NotesNotifier>(
            builder: (ctx, notifier, _) => Badge(
              offset: Offset(-3, 23),
              label: Text("${notifier.notes.length}"),
              isLabelVisible: notifier.notes.isNotEmpty,
              child: PopupMenuButton<String>(
                offset: Offset(0, 45),
                icon: Icon(Icons.note_alt_outlined),
                tooltip: "Нотатки",
                itemBuilder: (ctx) => [
                  ...notifier.notes.map(
                    (note) => PopupMenuItem<String>(
                      value: note,
                      child: Row(
                        children: [
                          Expanded(child: Text(note)),
                          IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () {
                              Navigator.pop(ctx);
                              _onDeleteNote(note);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                    onTap: _onOpenNotes,
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text("Нова нотатка"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Selector<RecipeNotifier, int>(
            selector: (_, notifier) => notifier.favorites.length,
            builder: (ctx, count, _) => Badge(
              offset: Offset(-3, 23),
              label: Text("$count"),
              isLabelVisible: count > 0,
              child: PopupMenuButton<String>(
                tooltip: "Улюблене",
                padding: EdgeInsetsGeometry.all(2),
                offset: Offset(-10, 40),
                iconSize: 20,
                icon: Icon(Icons.favorite),
                itemBuilder: (ctx) => context
                    .read<RecipeNotifier>()
                    .favorites
                    .map(
                      (name) =>
                          PopupMenuItem<String>(value: name, child: Text(name)),
                    )
                    .toList(),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 200,
            minHeight: 200,
            maxHeight: double.infinity,
          ),
          child: Column(
            children: [
              _burgerBlock(context),
              _recipeBlock(context),
              _tabsRow(),
              if (_showIngredients) _ingredientsBlock(context),
              if (_showSteps) _stepsBlock(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: Text("Інгредієнти"),
          selected: _showIngredients,
          onSelected: (_) => _onShowIngredients(),
        ),
        SizedBox(width: 10),
        ChoiceChip(
          label: Text("Кроки"),
          selected: _showSteps,
          onSelected: (_) => _onShowSteps(),
        ),
      ],
    );
  }

  // region BURGER BLOCK
  Widget _burgerBlock(BuildContext context) {
    final bool isNarrow = MediaQuery.of(context).size.width < 500;
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    final isFav = context.watch<RecipeNotifier>().isFavorite(_dishName);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 4), // відступи з усіх боків
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.lunch_dining,
                  size: 100,
                  color: colors.primary,
                ),
              ),

              Positioned(
                bottom: 2,
                right: 2,
                child: IconButton.filledTonal(
                  onPressed: _onToggleFavorite,
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: Colors.redAccent,
                  ),
                  tooltip: "TAP ON IT ANF IT WILL FILL ^.^",
                ),
              ),

              Positioned(
                top: 10,
                left: 10,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 80,
                    maxWidth: isNarrow ? 95 : 150,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "Складність: Висока",
                      style: texts.labelLarge?.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // endregion

  // region RECEPT BLOCK
  Widget _recipeBlock(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                "РЕЦЕПТ",
                style: texts.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 1, 16, 0),
                      child: Text(
                        "Час приготування: \n5хв",
                        textAlign: TextAlign.center,
                        style: texts.titleMedium,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Кількість порцій:",
                          textAlign: TextAlign.center,
                          style: texts.titleMedium,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _onDecrementServings,
                              icon: Icon(Icons.remove),
                            ),
                            Consumer<RecipeNotifier>(
                              builder: (ctx, notifier, _) => Text(
                                "${notifier.servings}",
                                style: texts.titleMedium,
                              ),
                            ),
                            IconButton(
                              onPressed: _onIncrementServings,
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  // endregion

  // region INGREDIENTS
  Widget _ingredientsBlock(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    final servings = context.watch<RecipeNotifier>().servings;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1500),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          height: 400,
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                "Інгредієнти",
                style: texts.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colors.primary,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 15),
                  children: _ingredients.map((item) {
                    final amount = item.amount * servings / _baseServings;
                    return Card(
                      key: ValueKey(item.name),
                      margin: EdgeInsets.all(5),
                      child: ListTile(
                        title: Text(item.name, style: texts.labelLarge),
                        trailing: Text(
                          "${amount.toStringAsFixed(0)} ${item.unit}",
                          style: texts.labelLarge,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // endregion

  // region STEPS
  Widget _stepsBlock(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1500),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          height: 400,
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                "Кроки",
                style: texts.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colors.primary,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 15),
                  children: [
                    Card(
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              child: Text("1"),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Покласти сир на нижню булочку, а потім намастити сир кептчунезом",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              child: Text("2"),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Нарізати хліб, сир, ковбасу та помідори",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              child: Text("3"),
                            ),
                            SizedBox(width: 5),
                            Expanded(child: Text("Змішати майонез і кетчуп")),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              child: Text("4"),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Покласти сир на нижню булочку, а потім намастити сир кетчунезом",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              child: Text("5"),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Додати всі інші інгредієнти і смакувати",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              child: Text("6"),
                            ),
                            SizedBox(width: 5),
                            Expanded(child: Text("Насолоджуйтесь")),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // endregion
}
