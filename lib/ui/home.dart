import 'package:currydesignerlite/stores/how_to_make_store.dart';
import 'package:currydesignerlite/stores/recipe_store.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/recipe.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key key, this.title}) : super(key: key);
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
      ChangeNotifierProvider<HowToMakeStore>(
        create: (context) => HowToMakeStore(),
      )
    ], child: _Home()); // This tra
  }
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _filter = new TextEditingController();
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    FocusScopeNode currentFocus = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.home,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/");
          },
        ),
        title: Text('Curry Note Lite'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {},
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        // Keyboard is closed when tapping anywhere.
        onTap: () {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(bottom: bottomSpace),
            width: MediaQuery.of(context).size.width * 0.90,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 17),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "レシピ一覧",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//                width: MediaQuery.of(context).size.width * 0.90,
                  child: TextField(
                    onChanged: (value) => {
                      context.read<RecipeStore>().setSearchResult(value),
                    },
                    decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search),
                      hintText: 'Search...',
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ShowCurryItemList(),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/register-recipe'),
        icon: Icon(Icons.add),
        label: Text("レシピの追加"),
      ),
    );
  }
}

class ShowCurryItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: context.select((RecipeStore store) => store.getRecipes),
      builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Filtered by search result.
        final searchResult =
            context.select((RecipeStore store) => store.getSearchResult);
        snapshot.data
            .removeWhere((item) => !(item.getName.contains(searchResult)));

        if (snapshot.data.length == 0) {
          return Container(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Text(
              "検索結果が0件です",
              style: TextStyle(fontSize: 20.0),
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16.0),
            itemBuilder: (context, i) {
              final item = snapshot.data[i];
              return Slidable(
                key: Key(item.getName),
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                  color: Colors.white,
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/note', arguments: {
                          "id": item.id,
                          "recipeName": item.getName,
                          "maxVersion": item.getMaxVersion,
                          "starCount": item.getStarCount,
                        });
                      },
                      child: Card(
                        child: ListTile(
                          leading: Icon(
                            IconData(0xe800, fontFamily: 'Curry'),
                            color: Color.fromRGBO(105, 105, 105, 1.0),
                            size: 40,
                          ),
                          title: Text(
                            item.getName,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          subtitle: Text("更新日: " + item.getLatestUpdateDate),
                        ),
                      )),
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
            itemCount: snapshot.data.length,
          );
        }
      },
    );
  }

  void _showDialog(int i, Recipe item, BuildContext context) => {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('削除'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('このレシピを削除しますか？'),
                    Text(
                      '\n※削除するとバージョンも全て削除されます。\n※復元もできません。',
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("CANCEL"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                      child: Text("OK"),
                      onPressed: () => _deleteRecipe(item, context))
                ],
              );
            })
      };

  void _deleteRecipe(Recipe item, BuildContext context) => {
        context.read<RecipeStore>().deleteRecipe(item.id),
        context.read<VersionStore>().deleteVersionByRecipeId(item.id),
        context.read<HowToMakeStore>().deleteHowToMakeByRecipeId(item.id),
        Navigator.pop(context)
      };
}
