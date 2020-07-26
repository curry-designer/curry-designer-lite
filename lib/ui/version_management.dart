import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class VersionManagement extends StatelessWidget {
  VersionManagement({Key key, this.snapshot, this.args}) : super(key: key);
  final AsyncSnapshot<List<Version>> snapshot;
  final Map args;
  @override
  Widget build(BuildContext context) {
    return _VersionManagement(snapshot: snapshot, args: args);
  }
}

class _VersionManagement extends StatelessWidget {
  _VersionManagement({Key key, this.snapshot, this.args}) : super(key: key);
  final AsyncSnapshot<List<Version>> snapshot;
  final Map args;
  @override
  Widget build(BuildContext context) {
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

    return GestureDetector(
      // 入力キーボードをどこを押しても閉じれるようにする。
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomSpace),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.only(top: 10.0),
                  width: MediaQuery.of(context).size.width * 0.88,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        // Versionと星の数を両端に寄せる。
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          DropdownButton(
                            hint: Text('Version: ' + currentVersion.toString()),
                            value: currentVersion,
                            items: snapshot.data.map((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  'Version: ' + item.getId.toString(),
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
                                      starCount >= 1
                                          ? Icons.star
                                          : Icons.star_border,
                                      color:
                                          starCount >= 1 ? Colors.amber : null,
                                      size: 30,
                                    ),
                                    onPressed: () => updateStarCount(
                                        versionMap[currentVersion], 1, context),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0.0),
                                  width: 30.0,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0.0),
                                    icon: Icon(
                                      starCount >= 2
                                          ? Icons.star
                                          : Icons.star_border,
                                      color:
                                          starCount >= 2 ? Colors.amber : null,
                                      size: 30,
                                    ),
                                    onPressed: () => updateStarCount(
                                        versionMap[currentVersion], 2, context),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0.0),
                                  width: 30.0,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0.0),
                                    icon: Icon(
                                      starCount >= 3
                                          ? Icons.star
                                          : Icons.star_border,
                                      color:
                                          starCount >= 3 ? Colors.amber : null,
                                      size: 30,
                                    ),
                                    onPressed: () => updateStarCount(
                                        versionMap[currentVersion], 3, context),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0.0),
                                  width: 30.0,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0.0),
                                    icon: Icon(
                                      starCount >= 4
                                          ? Icons.star
                                          : Icons.star_border,
                                      color:
                                          starCount >= 4 ? Colors.amber : null,
                                      size: 30,
                                    ),
                                    onPressed: () => updateStarCount(
                                        versionMap[currentVersion], 4, context),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0.0),
                                  width: 30.0,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0.0),
                                    icon: Icon(
                                      starCount >= 5
                                          ? Icons.star
                                          : Icons.star_border,
                                      color:
                                          starCount >= 5 ? Colors.amber : null,
                                      size: 30,
                                    ),
                                    onPressed: () => updateStarCount(
                                        versionMap[currentVersion], 5, context),
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
                              versionMap[currentVersion].getLatestUpdateDate),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                        child: TextFormField(
                          key: Key(currentVersion.toString()),
                          initialValue: versionMap[currentVersion].getComment,
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
                          style: const TextStyle(fontSize: 15.0),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
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
    );
  }

  void updateStarCount(Version version, int i, BuildContext context) {
    // 星の数をセットする。
    context.read<VersionStore>().setStarCount(i);

    // DBの星の数をUpdateする。
    context.read<VersionStore>().updateStarCount(new Version(
          id: version.getId,
          recipeId: version.getRecipeId,
          updateDate: DateFormat("yyyy.MM.dd").format(new DateTime.now()),
          starCount: i,
        ));
  }
}
