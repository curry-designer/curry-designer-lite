import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/stores/recipe_store.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import 'package:intl/intl.dart';

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
    final textController =
        context.select((VersionStore store) => store.getController);
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

        // Set initial comment.
        textController.text = versionMap[currentVersion].getComment == null ||
                versionMap[currentVersion].getComment == ''
            ? ''
            : versionMap[currentVersion].getComment;
        textController.selection =
            TextSelection.collapsed(offset: textController.text.length);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.home,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/");
                }),
            title: Text('バージョン管理'),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
                context.read<VersionStore>().setDropdownVersion(currentVersion);
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: SingleChildScrollView(
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
                              child: Text(
                                "メモ",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
//                          Container(
//                            margin: const EdgeInsets.all(0.0),
//                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//                            width: MediaQuery.of(context).size.width * 0.90,
//                            child: new TextFormField(
//                              initialValue:
//                                  versionMap[currentVersion].getComment,
//                              onChanged: (String value) => updateComment(
//                                  versionMap[currentVersion], value, context),
//                              maxLength: 140,
//                              maxLines: 15,
//                              decoration: InputDecoration(
//                                border: OutlineInputBorder(),
//                              ),
//                            ),
//                          ),
                          Container(
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: new TextField(
                              controller: textController,
                              onChanged: (value) => updateCommentByController(
                                  versionMap[currentVersion],
                                  value,
                                  context,
                                  textController),
                              onSubmitted: (value) =>
                                  textController.text = value,
                              maxLength: 140,
                              maxLines: 15,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            padding: const EdgeInsets.fromLTRB(0, 70, 15, 30),
                            child: FloatingActionButton(
                              onPressed: () => _showDialog(
                                  versionMap[currentVersion],
                                  maxVersion,
                                  context),
                              child: Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.history,
                  size: 40,
                ),
                title: Text(
                  'バージョン管理',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  const IconData(0xe800, fontFamily: 'Material'),
                  color: Color.fromRGBO(105, 105, 105, 1.0),
                  size: 40,
                ),
                title: Text(
                  '材料',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  const IconData(0xe800, fontFamily: 'Knife'),
                  color: Color.fromRGBO(105, 105, 105, 1.0),
                  size: 40,
                ),
                title: Text(
                  '作り方',
                  style: TextStyle(fontSize: 12),
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

  void updateComment(Version version, String value, BuildContext context) {
    // Set comment.
//    context.read<VersionStore>().setComment(value);

    // Update version in db.
    context.read<VersionStore>().updateComment(new Version(
          id: version.getId,
          recipeId: version.getRecipeId,
          updateDate: DateFormat("yyyy.MM.dd").format(new DateTime.now()),
          comment: value,
        ));
  }

  void updateCommentByController(
    Version version,
    String value,
    BuildContext context,
    TextEditingController controller,
  ) {
    // Update version in db.
    context.read<VersionStore>().updateComment(new Version(
          id: version.getId,
          recipeId: version.getRecipeId,
          updateDate: DateFormat("yyyy.MM.dd").format(new DateTime.now()),
          comment: value,
        ));
  }

  void _setComment(TextEditingController controller) {
    controller.text;
  }

  void _showDialog(Version version, int maxVersion, BuildContext context) => {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('バージョンの追加'),
                content: Text('新しくバージョンを追加しますか？'),
                actions: <Widget>[
                  FlatButton(
                    child: Text("CANCEL"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                      child: Text("OK"),
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
