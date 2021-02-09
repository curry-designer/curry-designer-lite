import 'package:currydesignerlite/common/constants.dart';
import 'package:currydesignerlite/models/curry_material.dart';
import 'package:currydesignerlite/models/how_to_make.dart';
import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/stores/curry_material_store.dart';
import 'package:currydesignerlite/stores/how_to_make_store.dart';
import 'package:currydesignerlite/stores/version_filter_store.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../common/enums/version_sort_key.dart';
import 'how_to_make_note.dart';
import 'material_note.dart';
import 'version_filter.dart';
import 'version_management.dart';

class Note extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<VersionStore>(
        create: (context) => VersionStore(),
      ),
      ChangeNotifierProvider<CurryMaterialStore>(
        create: (context) => CurryMaterialStore(),
      ),
      ChangeNotifierProvider<VersionFilterStore>(
        create: (context) => VersionFilterStore(),
      ),
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

    // デフォルトのソートキー
    final _sort = context.select((VersionStore store) => store.getSortKey);
    final _conditionStarCount =
        context.select((VersionStore store) => store.getConditionStarCount);
    final _conditionFreeWord =
        context.select((VersionStore store) => store.getConditionFreeWord);

    return FutureBuilder<List<Version>>(
      future: context.select((VersionStore store) => store.fetchVersions(
            recipeId: id,
            sortKey: _sort,
            starCount: _conditionStarCount,
            freeWord: _conditionFreeWord,
          )),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // ソート順の先頭のVersionを初期表示するためにCurrentVersionをセットする.
        if (context.select((VersionStore store) => store.isHeadPullDown) &&
            !context.select((VersionStore store) => store.isFiltered)) {
          _setOrderHeadContents(
              context, id, _sort, _conditionStarCount, _conditionFreeWord);
        }

        if (snapshot.data.length == 0) {
          return Scaffold(
            appBar: _appBar(
              id,
              versionMap[currentVersion],
              maxVersion,
              // starCount,
              recipeName,
              currentIndex,
              context,
              _sort,
            ),
            body: context.select((VersionStore store) => store.isFiltered)
                ? VersionFilter()
                : const Center(
                    child: Text(
                      '検索結果が0件です。',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
            bottomNavigationBar:
                context.select((VersionStore store) => store.isFiltered)
                    ? BottomAppBar(
                        child: ElevatedButton(
                          onPressed: () => {
                            _setFilterConditions(context),
                            _initializeFilterConditions(context),
                            context.read<VersionStore>().isFilteredFalse(),
                          },
                          child: const Text(
                            '絞り込む',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                            primary: Colors.amber,
                            shape: const StadiumBorder(),
                          ),
                        ),
                      )
                    : null,
          );
        }

        // Convert version list to map.
        context.read<VersionStore>().convertVersionListsToMap(snapshot.data);

        // Noteページに表示する子要素のリスト.
        final _pageWidgets = [
          VersionManagement(snapshot: snapshot),
          MaterialNoteWidget(),
          HowToMakeNote(),
        ];

        return Scaffold(
          appBar: _appBar(
            id,
            versionMap[currentVersion],
            maxVersion,
            // starCount,
            recipeName,
            currentIndex,
            context,
            _sort,
          ),
          resizeToAvoidBottomInset: false,
          body: context.select((VersionStore store) => store.isFiltered)
              ? VersionFilter()
              : _pageWidgets.elementAt(context
                  .select((VersionStore store) => store.getCurrentIndex)),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: _floatingActionButton(
            versionMap[currentVersion],
            maxVersion,
            recipeName,
            currentIndex,
            context,
          ),
          bottomNavigationBar:
              context.select((VersionStore store) => store.isFiltered)
                  ? BottomAppBar(
                      child: ElevatedButton(
                        onPressed: () => {
                          _setFilterConditions(context),
                          _initializeFilterConditions(context),
                          context.read<VersionStore>().isFilteredFalse(),
                        },
                        child: const Text(
                          '絞り込む',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          primary: Colors.amber,
                          shape: const StadiumBorder(),
                        ),
                      ),
                    )
                  : BottomNavigationBar(
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

  PreferredSizeWidget _appBar(
    int id,
    Version version,
    int maxVersion,
    // int starCount,
    String recipeName,
    int currentIndex,
    BuildContext context,
    VersionSortKeyEnum sort,
  ) {
    if (context.select((VersionStore store) => store.isFiltered)) {
      return AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              context.read<VersionStore>().isFilteredFalse();
              context.read<VersionStore>().isHeadPullDownFalse();
              _initializeFilterConditions(context);
            }),
        title: const Text('フィルター'),
      );
    }
    switch (currentIndex) {
      case 0:
        return AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.home,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              }),
          title: Text(recipeName),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                MaterialCommunityIcons.filter_plus,
              ),
              onPressed: () {
                context.read<VersionStore>().isFilteredTrue();
                context.read<VersionStore>().isHeadPullDownTrue();
              },
            ),
          ],
        );
      case 1:
        return AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.home,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              }),
          title: Text(recipeName),
        );
      case 2:
        return AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.home,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              }),
          title: Text(recipeName),
        );
      default:
        return null;
    }
  }

  Widget _floatingActionButton(
    Version version,
    int maxVersion,
    String recipeName,
    int currentIndex,
    BuildContext context,
  ) {
    if (context.select((VersionStore store) => store.isFiltered)) {
      return null;
    }
    switch (currentIndex) {
      case 0:
        return FloatingActionButton.extended(
          onPressed: () => _showDialog(
            version,
            maxVersion,
            recipeName,
            context,
          ),
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

  Future<void> _setOrderHeadContents(
      BuildContext context,
      int id,
      VersionSortKeyEnum sort,
      int conditionStarCount,
      String conditionFreeWord) async {
    await context.select((VersionStore store) => store.fetchVersions(
          recipeId: id,
          sortKey: sort,
          starCount: conditionStarCount,
          freeWord: conditionFreeWord,
        ));
    final resultList = context.read<VersionStore>().getFetchResult;
    if (resultList.length != 0) {
      context.read<VersionStore>().setVersion(resultList[0].getId);
      context
          .read<VersionStore>()
          .setStarCount(resultList[0].getStarCount, false);
      context.read<VersionStore>().isHeadPullDownFalse();
    }
  }

  void _initializeFilterConditions(BuildContext context) {
    context.read<VersionFilterStore>().setSortKey(VersionSortKeyEnum.VERSION);
    context.read<VersionFilterStore>().setStarCount(INITIALIZE_STAR_COUNT);
    context.read<VersionFilterStore>().setFreeWord('');
    context.read<VersionFilterStore>().changeOpenStarCountFlagFalse();
    context.read<VersionFilterStore>().changeOpenFreeWordFlagFalse();
  }

  void _setFilterConditions(BuildContext context) {
    context
        .read<VersionStore>()
        .setSortKey(context.read<VersionFilterStore>().getSortKey);
    context
        .read<VersionStore>()
        .setConditionStarCount(context.read<VersionFilterStore>().getStarCount);
    context
        .read<VersionStore>()
        .setConditionFreeWord(context.read<VersionFilterStore>().getFreeWord);
  }
}
