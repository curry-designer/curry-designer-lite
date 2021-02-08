import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/stores/recipe_store.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';

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
    // 入力キーボードをどこを押しても閉じれるようにするための現在のフォーカスを定義。
    final currentFocus = FocusScope.of(context);

    return GestureDetector(
      // 入力キーボードをどこを押しても閉じれるようにする。
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('レシピの登録'),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(50),
            child: SingleChildScrollView(
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
                      context.read<RecipeStore>().recipeName = value;
                    },
                  ),
                  RaisedButton(
                    onPressed: () => _register(
                        context.read<RecipeStore>().getCurryRecipeName,
                        context),
                    child: const Text('登録'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register(String data, BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await context.read<RecipeStore>().createRecipe(Recipe(
            name: data,
          ));
      final recipes = await context.read<RecipeStore>().fetchLatestRecipesId();
      final recipeId = recipes[0].getId;
      await context.read<VersionStore>().createVersion(Version(
            recipeId: recipeId,
            updateDateTime:
                DateFormat('yyyy.MM.dd HH:mm:ss').format(new DateTime.now()),
            starCount: 0,
          ));

      Navigator.pushNamed(context, '/note', arguments: {
        'id': recipeId,
        'recipeName': recipes[0].getName,
        'maxVersion': 1,
        'starCount': 0,
      });
    }
  }
}
