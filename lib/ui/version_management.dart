import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VersionManagement extends StatelessWidget {
  const VersionManagement({Key key, this.snapshot}) : super(key: key);
  final AsyncSnapshot<List<Version>> snapshot;
  @override
  Widget build(BuildContext context) {
    return _VersionManagement(snapshot: snapshot);
  }
}

class _VersionManagement extends StatelessWidget {
  const _VersionManagement({Key key, this.snapshot}) : super(key: key);
  final AsyncSnapshot<List<Version>> snapshot;
  @override
  Widget build(BuildContext context) {
    final args = context.select((VersionStore store) => store.getArgs);
    final maxVersion = args['maxVersion'] as int;
    final currentVersion =
        context.select((VersionStore store) => store.getVersion) == null
            ? maxVersion
            : context.select((VersionStore store) => store.getVersion);
    final versionMap =
        context.select((VersionStore store) => store.getMapVersions);
    final starCount =
        context.select((VersionStore store) => store.getStarCount) == null
            ? args['starCount'] as int
            : context.select((VersionStore store) => store.getStarCount);

    // 入力キーボードをどこを押しても閉じれるようにするための現在のフォーカスを定義。
    final currentFocus = FocusScope.of(context);

    // 入力キーボードを使用の際に全体のBottomをあげる。入力キーボードでフォームが隠れてしまうため。
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
          // 入力キーボードを使用の際に全体のBottomをあげる。入力キーボードでフォームが隠れてしまうため。
          padding: EdgeInsets.only(bottom: bottomSpace),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width * 0.88,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        // Versionと星の数を両端に寄せる。
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          DropdownButton(
                              hint:
                                  Text('Version: ${currentVersion.toString()}'),
                              value: currentVersion,
                              items: snapshot.data.map((item) {
                                return DropdownMenuItem(
                                  child: Text(
                                    'Version: ${item.getId.toString()}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  value: item.getId,
                                );
                              }).toList(),
                              onChanged: (int value) => {
                                    context
                                        .read<VersionStore>()
                                        .setDropdownVersion(value),
                                    // context
                                    //     .read<VersionStore>()
                                    //     .setCurrentVersion(value),
                                  }),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  width: 30,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
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
                                  padding: const EdgeInsets.all(0),
                                  width: 30,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
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
                                  padding: const EdgeInsets.all(0),
                                  width: 30,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
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
                                  padding: const EdgeInsets.all(0),
                                  width: 30,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
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
                                  padding: const EdgeInsets.all(0),
                                  width: 30,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
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
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              '更新日時: ${versionMap[currentVersion].getLatestUpdateDateTime}'),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'メモ',
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
                                    Version(
                                      id: versionMap[currentVersion].getId,
                                      recipeId: versionMap[currentVersion]
                                          .getRecipeId,
                                      updateDateTime:
                                          DateFormat('yyyy.MM.dd HH:mm:ss')
                                              .format(DateTime.now()),
                                      comment: value,
                                    ),
                                  ),
                          onTap: () => context
                              .read<VersionStore>()
                              .isTextFieldOpenFalse(),
                          maxLength: 140,
                          maxLines: 13,
                          style: const TextStyle(fontSize: 15),
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
    context.read<VersionStore>().setStarCount(i, true);

    // DBの星の数をUpdateする。
    context.read<VersionStore>().updateStarCount(
          Version(
            id: version.getId,
            recipeId: version.getRecipeId,
            updateDateTime:
                DateFormat('yyyy.MM.dd HH:mm:ss').format(DateTime.now()),
            starCount: i,
          ),
        );
  }
}
