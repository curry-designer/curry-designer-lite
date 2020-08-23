import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/models/how_to_make.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:currydesignerlite/stores/how_to_make_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HowToMakeNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _HowToMakeNote();
  }
}

class _HowToMakeNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map args = context.select((VersionStore store) => store.getArgs);
    final maxVersion = args["maxVersion"];
    final currentVersion =
        context.select((VersionStore store) => store.getVersion) == null
            ? maxVersion
            : context.select((VersionStore store) => store.getVersion);
    final versionMap =
        context.select((VersionStore store) => store.getMapVersions);

    // 入力キーボードをどこを押しても閉じれるようにするための現在のフォーカスを定義。
    FocusScopeNode currentFocus = FocusScope.of(context);

    // 入力キーボードを使用の際に全体のBottomをあげる。入力キーボードでフォームが隠れてしまうため。
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      // Keyboard is closed when tapping anywhere.
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SingleChildScrollView(
        reverse: context.select((HowToMakeStore store) => store.getReverseFlag),
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
                    children: <Widget>[
                      Row(
                        // 作り方とVersionを両端に寄せる。
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  "Version: " + currentVersion.toString(),
                                  style: const TextStyle(fontSize: 25.0)),
                            ),
                          ),
                        ],
                      ),
                      _HowToMakeList(
                          recipeId: versionMap[currentVersion].getRecipeId,
                          versionId: currentVersion),
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
}

class _HowToMakeList extends StatelessWidget {
  _HowToMakeList({Key key, this.recipeId, this.versionId}) : super(key: key);
  final int recipeId;
  final int versionId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HowToMake>>(
      future: context.select((HowToMakeStore store) =>
          store.fetchHowToMakes(recipeId: recipeId, versionId: versionId)),
      builder: (context, AsyncSnapshot<List<HowToMake>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            final item = snapshot.data[i];
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "作り方" + item.getOrderHowToMake.toString(),
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ),
                      Container(
                        child: Row(children: <Widget>[
                          item.getOrderHowToMake != snapshot.data.length
                              ? Container(
                                  child: IconButton(
                                    icon: Icon(const IconData(0xe801,
                                        fontFamily: 'Down')),
                                    color: Colors.amber,
                                    onPressed: () {
                                      context
                                          .read<HowToMakeStore>()
                                          .updateOrderHowToMakeDown(
                                              item,
                                              DateFormat("yyyy.MM.dd")
                                                  .format(new DateTime.now()));
                                    },
                                  ),
                                )
                              : Container(),
                          item.getOrderHowToMake != 1
                              ? Container(
                                  child: IconButton(
                                    icon: Icon(const IconData(0xe802,
                                        fontFamily: 'Up')),
                                    color: Colors.amber,
                                    onPressed: () {
                                      context
                                          .read<HowToMakeStore>()
                                          .updateOrderHowToMakeUp(
                                              item,
                                              DateFormat("yyyy.MM.dd")
                                                  .format(new DateTime.now()));
                                    },
                                  ),
                                )
                              : Container(),
                        ]),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Slidable(
                    key: Key(item.getId.toString()),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      color: Colors.white,
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/how_to_make_note_detail',
                                arguments: {
                                  "id": item.id,
                                  "recipeId": item.getRecipeId,
                                  "versionId": item.getVersionId,
                                  "orderHowToMake": item.getOrderHowToMake,
                                  "howToMake": item.getHowToMake
                                });
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(
                                item.getHowToMake,
                                style: TextStyle(fontSize: 15.0),
                              ),
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
                  ),
                ),
              ],
            );
          },
          itemCount: snapshot.data.length,
        );
      },
    );
  }

  void _showDialog(int i, HowToMake item, BuildContext context) => {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('削除'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                        '作り方' + item.getOrderHowToMake.toString() + 'を削除しますか？'),
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

  void _deleteRecipe(HowToMake item, BuildContext context) async => {
        await context
            .read<HowToMakeStore>()
            .deleteHowToMake(item.id, item.getRecipeId, item.getVersionId),
        await context.read<HowToMakeStore>().updateOrderHowToMake(
            item, DateFormat("yyyy.MM.dd").format(new DateTime.now())),
        Navigator.pop(context)
      };
}
