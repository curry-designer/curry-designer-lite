import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/models/how_to_make.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:currydesignerlite/stores/how_to_make_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'version_management.dart';
import 'material_note.dart';
import 'how_to_make_note.dart';

class Note extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<VersionStore>(
        create: (context) => VersionStore(),
      ),
      ChangeNotifierProvider<HowToMakeStore>(
        create: (context) => HowToMakeStore(),
      )
    ], child: _Note());
  }
}

class _Note extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.select((VersionStore store) =>
        store.setArgs(ModalRoute.of(context).settings.arguments));
    final Map args = context.select((VersionStore store) => store.getArgs);
    final id = args["id"];
    final recipeName = args["recipeName"];
    final maxVersion = args["maxVersion"];
    final currentVersion =
        context.select((VersionStore store) => store.getVersion) == null
            ? maxVersion
            : context.select((VersionStore store) => store.getVersion);
    final versionMap =
        context.select((VersionStore store) => store.getMapVersions);
    final currentIndex =
        context.select((VersionStore store) => store.getCurrentIndex);

    return FutureBuilder<List<Version>>(
      future: context
          .select((VersionStore store) => store.fetchVersions(recipeId: id)),
      builder: (context, AsyncSnapshot<List<Version>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        // Convert version list to map.
        context.select((VersionStore store) =>
            store.convertVersionListsToMap(snapshot.data));

        // Noteページに表示する子要素のリスト.
        final _pageWidgets = [
          VersionManagement(snapshot: snapshot),
          MaterialNoteWidget(),
          HowToMakeNote(),
        ];

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(
                  Icons.home,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/");
                }),
            title: Text(recipeName),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.settings,
                ),
                onPressed: () {},
              ),
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: _pageWidgets.elementAt(
              context.select((VersionStore store) => store.getCurrentIndex)),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: _floatingActionButton(
              versionMap[currentVersion],
              maxVersion,
              recipeName,
              currentIndex,
              context),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.history,
                  size: 40,
                ),
                title: const Text(
                  'バージョン管理',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  const IconData(0xe800, fontFamily: 'Material'),
                  size: 40,
                ),
                title: const Text(
                  '材料',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  const IconData(0xe800, fontFamily: 'Knife'),
                  size: 40,
                ),
                title: Text(
                  '作り方',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
            currentIndex: currentIndex,
            onTap: (int index) {
              context.read<HowToMakeStore>().changeReverseFlagFalse();
              context.read<VersionStore>().setCurrentIndex(index);
            },
          ),
        );
      },
    );
  }

  Widget _floatingActionButton(Version version, int maxVersion,
      String recipeName, int currentIndex, BuildContext context) {
    switch (currentIndex) {
      case 0:
        return FloatingActionButton.extended(
          onPressed: () =>
              _showDialog(version, maxVersion, recipeName, context),
          icon: const Icon(Icons.add),
          label: const Text("このバージョンから更新"),
        );
      case 1:
        return FloatingActionButton.extended();
      case 2:
        return FloatingActionButton.extended(
          onPressed: () => {
            context.read<HowToMakeStore>().createHowToMake(HowToMake(
                  recipeId: version.getRecipeId,
                  versionId: version.getId,
                ))
          },
          icon: const Icon(Icons.add),
          label: const Text("作り方を追加"),
        );
      default:
        return FloatingActionButton.extended();
    }
  }

  void _showDialog(Version version, int maxVersion, String recipeName,
          BuildContext context) =>
      {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('レシピの更新'),
                content: const Text('レシピの更新をしますか？'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text("CANCEL"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                      child: const Text("OK"),
                      onPressed: () => _createVersion(
                          version, maxVersion, recipeName, context)),
                ],
              );
            })
      };

  void _createVersion(Version version, int maxVersion, String recipeName,
          BuildContext context) async =>
      {
        await context.read<VersionStore>().createVersion(Version(
              recipeId: version.getRecipeId,
              updateDate: DateFormat("yyyy.MM.dd").format(new DateTime.now()),
              starCount: 0,
            )),
        await Navigator.pushNamed(context, '/note', arguments: {
          "id": version.getRecipeId,
          "recipeName": recipeName,
          "maxVersion": maxVersion + 1,
          "starCount": 0,
        }),
      };
}
