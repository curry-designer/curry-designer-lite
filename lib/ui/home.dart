import 'package:currydesignerlite/stores/curry_material_store.dart';
import 'package:currydesignerlite/stores/how_to_make_store.dart';
import 'package:currydesignerlite/stores/recipe_store.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';

class Home extends StatelessWidget {
  const Home({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<RecipeStore>(
        create: (context) => RecipeStore(),
      ),
      ChangeNotifierProvider<VersionStore>(
        create: (context) => VersionStore(),
      ),
      // ChangeNotifierProvider<HowToMakeStore>(
      //   create: (context) => HowToMakeStore(),
      // ),
      ChangeNotifierProvider<CurryMaterialStore>(
        create: (context) => CurryMaterialStore(),
      )
    ], child: _Home()); // This tra
  }
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
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
          leading: IconButton(
            icon: const Icon(
              Icons.home,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          title: const Text('Curry Note'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(bottom: bottomSpace),
            width: MediaQuery.of(context).size.width * 0.90,
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 17),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'レシピ一覧',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextField(
                    onSubmitted: (value) => {
                      _checkSearchParameter(context, value),
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ShowCurryItemList(),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, '/register-recipe'),
          icon: const Icon(Icons.add),
          label: const Text('レシピの追加'),
        ),
      ),
    );
  }

  void _checkSearchParameter(BuildContext context, String parameter) {
    final fetchResult = context.read<RecipeStore>().getFetchResult;
    final fetchFilterResult =
        fetchResult.where((item) => item.getName.contains(parameter)).toList();
    if (fetchFilterResult.length == 0) {
      //_showDialogForFilter(context);
      context.read<RecipeStore>().setSearchResult(parameter);
    } else {
      context.read<RecipeStore>().setSearchResult(parameter);
      context.read<RecipeStore>().changeSearchFlag();
    }
  }

  // void _showDialogForFilter(BuildContext context) => {
  //       showDialog<void>(
  //         context: context,
  //         builder: (_) {
  //           return Container(
  //             color: Colors.deepOrange,
  //             // alignment: Alignment.center,
  //             child: AlertDialog(
  //               title: const Text('検索結果が0件です'),
  //               actions: <Widget>[
  //                 FlatButton(
  //                   child: const Text('OK'),
  //                   onPressed: () => Navigator.pop(context),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       )
  //     };
}

class ShowCurryItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: context.select((RecipeStore store) => store.getRecipes),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(''),
          );
        }

        // Filtered by search result.
        final searchResult =
            context.select((RecipeStore store) => store.getSearchResult);

        List<Recipe> filteredSnapshotData = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done) {
          context.read<RecipeStore>().setFetchResult(snapshot.data);
          filteredSnapshotData = snapshot.data
              .where((item) => item.getName.contains(searchResult))
              .toList();

          if (filteredSnapshotData.length == 0) {
            return Container(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text(
                context.select((RecipeStore store) => store.isSearch)
                    ? '検索結果が0件です'
                    : '',
                style: const TextStyle(fontSize: 18),
              ),
            );
          }
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 16),
          itemBuilder: (_, i) {
            final item = filteredSnapshotData[i];
            return Slidable(
              key: Key(item.getName),
              actionPane: const SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/note',
                      arguments: {
                        'id': item.id,
                        'recipeName': item.getName,
                        'maxVersion': item.getMaxVersion,
                        'starCount': item.getStarCount,
                      },
                    );
                  },
                  child: Card(
                    child: ListTile(
                      leading: const Icon(
                        IconData(0xe800, fontFamily: 'Curry'),
                        color: Color.fromRGBO(105, 105, 105, 1),
                        size: 50,
                      ),
                      title: Text(
                        item.getName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Text('更新日: ${item.getLatestUpdateDate}'),
                    ),
                  ),
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () => _showDialog(i, item, context),
                ),
              ],
            );
          },
          itemCount: filteredSnapshotData.length,
        );
      },
    );
  }

  void _showDialog(int i, Recipe item, BuildContext context) => {
        showDialog<void>(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('削除'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  const Text('このレシピを削除しますか？'),
                  const Text(
                    '\n※削除するとバージョンも全て削除されます。\n※復元もできません。',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                    child: const Text('OK'),
                    onPressed: () => _deleteRecipe(item, context))
              ],
            );
          },
        )
      };

  void _deleteRecipe(Recipe item, BuildContext context) => {
        context.read<RecipeStore>().deleteRecipe(item.id),
        context.read<VersionStore>().deleteVersionByRecipeId(item.id),
        context.read<HowToMakeStore>().deleteHowToMakeByRecipeId(item.id),
        context
            .read<CurryMaterialStore>()
            .deleteCurryMaterialByRecipeId(item.id),
        Navigator.pop(context)
      };
}
