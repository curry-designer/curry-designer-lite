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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeStore>(
          create: (_) => RecipeStore(),
        ),
        ChangeNotifierProvider<VersionStore>(
          create: (_) => VersionStore(),
        )
      ],
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.home,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/");
                }),
            title: Text(title),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 17, 10, 2),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "レシピ一覧",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  )),
              Expanded(
                child: ShowCurryItemList(),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/register-recipe'),
            child: Icon(Icons.add),
          )),
    ); // This tra
  }
}

class ShowCurryItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<RecipeStore>(context);
    Future<List<Recipe>> curryItemList = bloc.getRecipes;
    return FutureBuilder<List<Recipe>>(
        future: bloc.getRecipes,
        builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
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
                        Navigator.pushNamed(context, '/version-management',
                            arguments: item.id);
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
                          subtitle: Text("latest update: " +
                              item.latestUpdateDate.toString()),
                        ),
                      )),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => _showDialog(i, snapshot.data[i], context),
                  ),
                ],
              );
            },
            itemCount: snapshot.data.length,
          );
        });
  }

  void _showDialog(int i, Recipe item, context) => {
        showDialog(
            context: context,
            builder: (_) {
              final bloc = Provider.of<RecipeStore>(context);
              return AlertDialog(
                title: Text('削除'),
                content: Text('このレシピを削除してもよろしいですか？'),
                actions: <Widget>[
                  FlatButton(
                    child: Text("CANCEL"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                      child: Text("OK"),
                      onPressed: () => _deleteRecipe(item, context, bloc))
                ],
              );
            })
      };

  void _deleteRecipe(Recipe item, context, bloc) => {
        Provider.of<RecipeStore>(context, listen: false).deleteRecipe(item.id),
        Provider.of<VersionStore>(context, listen: false)
            .deleteVersionByRecipeId(item.id),
        Navigator.pushNamed(context, "/")
      };
}
