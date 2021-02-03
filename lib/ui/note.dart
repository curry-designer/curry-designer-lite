import 'package:currydesignerlite/models/curry_material.dart';
import 'package:currydesignerlite/models/how_to_make.dart';
import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/stores/curry_material_store.dart';
import 'package:currydesignerlite/stores/how_to_make_store.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'how_to_make_note.dart';
import 'material_note.dart';
import 'version_management.dart';

class Note extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<VersionStore>(
        create: (context) => VersionStore(),
      ),
      ChangeNotifierProvider<HowToMakeStore>(
        create: (context) => HowToMakeStore(),
      ),
      ChangeNotifierProvider<CurryMaterialStore>(
        create: (context) => CurryMaterialStore(),
      )
    ], child: _Note());
  }
}

class _Note extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.select((VersionStore store) => store.setArgs(
        ModalRoute.of(context).settings.arguments as Map<dynamic, dynamic>));
    final args = context.select((VersionStore store) => store.getArgs);
    final id = args['id'] as int;
    final recipeName = args['recipeName'] as String;
    final maxVersion = args['maxVersion'] as int;
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
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
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
                  Navigator.pushNamed(context, '/');
                }),
            title: Text(recipeName),
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
                  const IconData(0xe802, fontFamily: 'History'),
                  size: 40,
                ),
                label: 'バージョン管理',
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  const IconData(0xe800, fontFamily: 'Material'),
                  size: 40,
                ),
                label: '材料',
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  const IconData(0xe803, fontFamily: 'HowToMake'),
                  size: 40,
                ),
                label: '作り方',
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
          label: const Text('このバージョンから更新'),
        );
      case 1:
        return FloatingActionButton.extended(
          onPressed: () => {
            context
                .read<CurryMaterialStore>()
                .createCurryMaterial(CurryMaterial(
                  recipeId: version.getRecipeId,
                  versionId: version.getId,
                  materialName: '',
                  materialAmount: '',
                ))
          },
          icon: const Icon(Icons.add),
          label: const Text(
            '材料の追加',
            style: TextStyle(letterSpacing: 1),
          ),
        );
      case 2:
        return FloatingActionButton.extended(
          onPressed: () => {
            context.read<HowToMakeStore>().createHowToMake(HowToMake(
                  recipeId: version.getRecipeId,
                  versionId: version.getId,
                  howToMake: '',
                ))
          },
          icon: const Icon(Icons.add),
          label: const Text('作り方の追加'),
        );
      default:
        return null;
    }
  }

  void _showDialog(Version version, int maxVersion, String recipeName,
          BuildContext context) =>
      {
        showDialog<void>(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('レシピの更新'),
              content: const Text('レシピの更新をしますか？'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                    child: const Text('OK'),
                    onPressed: () => _createVersion(
                        version, maxVersion, recipeName, context)),
              ],
            );
          },
        )
      };

  Future<void> _createVersion(Version version, int maxVersion,
          String recipeName, BuildContext context) async =>
      {
        await context.read<VersionStore>().createVersion(Version(
              recipeId: version.getRecipeId,
              updateDateTime:
                  DateFormat('yyyy.MM.dd HH:mm:ss').format(new DateTime.now()),
              starCount: 0,
            )),
        await Navigator.pushNamed(
          context,
          '/note',
          arguments: {
            'id': version.getRecipeId,
            'recipeName': recipeName,
            'maxVersion': maxVersion + 1,
            'starCount': 0,
          },
        ),
      };
}
