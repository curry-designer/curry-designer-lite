import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/stores/recipe_store.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class VersionManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<VersionStore>(
        create: (context) => VersionStore(),
      )
    ], child: _VersionManagement());
  }
}

class _VersionManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    final maxVersion = args["maxVersion"];
    final currentVersion =
        context.select((VersionStore store) => store.getVersion) == null
            ? maxVersion
            : context.select((VersionStore store) => store.getVersion);
    final versionMap =
        context.select((VersionStore store) => store.getMapVersions);
    final starCount =
        context.select((VersionStore store) => store.getStarCount) == null
            ? args["starCount"]
            : context.select((VersionStore store) => store.getStarCount);

    FocusScopeNode currentFocus = FocusScope.of(context);

    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    return FutureBuilder<List<Version>>(
      future: context.select(
          (VersionStore store) => store.fetchVersions(recipeId: args["id"])),
      builder: (context, AsyncSnapshot<List<Version>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        // Convert version list to map.
        context.select((VersionStore store) =>
            store.convertVersionListsToMap(snapshot.data));

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(
                  Icons.home,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/");
                }),
            title: const Text('バージョン管理'),
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
          body: GestureDetector(
            // Keyboard is closed when tapping anywhere.
            onTap: () {
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
                // Make the update button visible.
                context.read<VersionStore>().isTextFieldOpenTrue();
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomSpace),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              DropdownButton(
                                hint: Text('version: ' +
                                    snapshot
                                        .data[snapshot.data.length - 1].getId
                                        .toString()),
                                value: currentVersion,
                                items: snapshot.data.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      'version: ' + item.getId.toString(),
                                      style: TextStyle(fontSize: 25.0),
                                    ),
                                    value: item.getId,
                                  );
                                }).toList(),
                                onChanged: (value) => context
                                    .read<VersionStore>()
                                    .setDropdownVersion(value),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(0.0),
                                      width: 30.0,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0.0),
                                        icon: Icon(
                                          // Add the lines from here...
                                          starCount >= 1
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: starCount >= 1
                                              ? Colors.amber
                                              : null,
                                          size: 30,
                                        ),
                                        onPressed: () => updateStarCount(
                                            versionMap[currentVersion],
                                            1,
                                            context),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(0.0),
                                      width: 30.0,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0.0),
                                        icon: Icon(
                                          // Add the lines from here...
                                          starCount >= 2
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: starCount >= 2
                                              ? Colors.amber
                                              : null,
                                          size: 30,
                                        ),
                                        onPressed: () => updateStarCount(
                                            versionMap[currentVersion],
                                            2,
                                            context),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(0.0),
                                      width: 30.0,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0.0),
                                        icon: Icon(
                                          // Add the lines from here...
                                          starCount >= 3
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: starCount >= 3
                                              ? Colors.amber
                                              : null,
                                          size: 30,
                                        ),
                                        onPressed: () => updateStarCount(
                                            versionMap[currentVersion],
                                            3,
                                            context),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(0.0),
                                      width: 30.0,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0.0),
                                        icon: Icon(
                                          // Add the lines from here...
                                          starCount >= 4
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: starCount >= 4
                                              ? Colors.amber
                                              : null,
                                          size: 30,
                                        ),
                                        onPressed: () => updateStarCount(
                                            versionMap[currentVersion],
                                            4,
                                            context),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(0.0),
                                      width: 30.0,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0.0),
                                        icon: Icon(
                                          // Add the lines from here...
                                          starCount >= 5
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: starCount >= 5
                                              ? Colors.amber
                                              : null,
                                          size: 30,
                                        ),
                                        onPressed: () => updateStarCount(
                                            versionMap[currentVersion],
                                            5,
                                            context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("更新日: " +
                                  versionMap[currentVersion]
                                      .getLatestUpdateDate),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                "メモ",
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: TextFormField(
                              key: Key(currentVersion.toString()),
                              initialValue:
                                  versionMap[currentVersion].getComment,
                              onChanged: (value) =>
                                  context.read<VersionStore>().updateComment(
                                        new Version(
                                          id: versionMap[currentVersion].getId,
                                          recipeId: versionMap[currentVersion]
                                              .getRecipeId,
                                          updateDate: DateFormat("yyyy.MM.dd")
                                              .format(new DateTime.now()),
                                          comment: value,
                                        ),
                                      ),
                              onTap: () => context
                                  .read<VersionStore>()
                                  .isTextFieldOpenFalse(),
                              maxLength: 140,
                              maxLines: 13,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
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
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () =>
                _showDialog(versionMap[currentVersion], maxVersion, context),
            icon: const Icon(Icons.add),
            label: const Text("このバージョンから更新"),
          ),
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
                  color: Color.fromRGBO(105, 105, 105, 1.0),
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
                  color: Color.fromRGBO(105, 105, 105, 1.0),
                  size: 40,
                ),
                title: Text(
                  '作り方',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
//        currentIndex: _selectedIndex,
//        selectedItemColor: Colors.amber[800],
            onTap: (int index) {
              Navigator.pushNamed(context, '/material-note');
            },
          ),
        );
      },
    );
  }

  void updateStarCount(Version version, int i, BuildContext context) {
    // Set star count.
    context.read<VersionStore>().setStarCount(i);

    // Update version in db.
    context.read<VersionStore>().updateStarCount(new Version(
          id: version.getId,
          recipeId: version.getRecipeId,
          updateDate: DateFormat("yyyy.MM.dd").format(new DateTime.now()),
          starCount: i,
        ));
  }

  void _showDialog(Version version, int maxVersion, BuildContext context) => {
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
                      onPressed: () =>
                          _createVersion(version, maxVersion, context)),
                ],
              );
            })
      };

  void _createVersion(
          Version version, int maxVersion, BuildContext context) async =>
      {
        await context.read<VersionStore>().createVersion(Version(
              recipeId: version.getRecipeId,
              updateDate: DateFormat("yyyy.MM.dd").format(new DateTime.now()),
              starCount: 0,
            )),
        await Navigator.pushNamed(context, '/version-management', arguments: {
          "id": version.getRecipeId,
          "maxVersion": maxVersion + 1,
          "starCount": 0,
        }),
      };
}
