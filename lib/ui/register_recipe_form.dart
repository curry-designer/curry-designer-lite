import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/stores/recipe_store.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import 'package:intl/intl.dart';

class RegisterRecipeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<RecipeStore>(
        create: (context) => RecipeStore(),
      ),
      ChangeNotifierProvider<VersionStore>(
        create: (context) => VersionStore(),
      )
    ], child: _RegisterRecipeForm());
  }
}

class _RegisterRecipeForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<RecipeStore>(context);
    context.select((RecipeStore store) => store.fetchRecipes);
    return Scaffold(
      appBar: AppBar(
        title: Text('レシピの登録'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                maxLength: 100,
                decoration: const InputDecoration(
                  hintText: 'バターチキンカレー etc...',
                  labelText: 'レシピ名',
                ),
                validator: (String value) {
                  return value.isEmpty ? 'レシピ名を入力してください。' : null;
                },
                onChanged: (String value) {
                  context.read<RecipeStore>().registerCurryRecipeName(value);
                },
              ),
              RaisedButton(
                onPressed: () => _register(bloc.getCurryRecipeName, context),
                child: Text('登録'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register(String data, BuildContext context) async {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      await context.read<RecipeStore>().createRecipe(Recipe(
            name: data,
          ));
      List<Recipe> recipes =
          await context.read<RecipeStore>().fetchLatestRecipesId();
      int recipeId = recipes[0].getId;
      await context.read<VersionStore>().createVersion(Version(
            recipeId: recipeId,
            updateDate: DateFormat("yyyy.MM.dd").format(new DateTime.now()),
            starCount: 0,
          ));
      Navigator.pushNamed(context, "/");
    }
  }
}
