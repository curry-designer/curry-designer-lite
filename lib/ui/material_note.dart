import 'package:currydesignerlite/models/curry_material.dart';
import 'package:currydesignerlite/stores/curry_material_store.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:currydesignerlite/stores/how_to_make_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MaterialNoteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MaterialNoteWidget();
  }
}

class _MaterialNoteWidget extends StatelessWidget {
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
        reverse:
            context.select((CurryMaterialStore store) => store.getReverseFlag),
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
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text("Version: " + currentVersion.toString(),
                              style: const TextStyle(fontSize: 25.0)),
                        ),
                      ),
                      _MaterialList(
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

class _MaterialList extends StatelessWidget {
  _MaterialList({Key key, this.recipeId, this.versionId}) : super(key: key);
  final int recipeId;
  final int versionId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CurryMaterial>>(
      future: context.select((CurryMaterialStore store) =>
          store.fetchCurryMaterials(recipeId: recipeId, versionId: versionId)),
      builder: (context, AsyncSnapshot<List<CurryMaterial>> snapshot) {
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
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Row(
                    // 作り方と順序アイコンを左右に寄せる。
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "材料" + item.getOrderMaterial.toString(),
                          style: const TextStyle(fontSize: 13.0),
                        ),
                      ),
                      Container(
                        child: Row(children: <Widget>[
                          item.getOrderMaterial != snapshot.data.length
                              ? Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      context
                                          .read<CurryMaterialStore>()
                                          .updateOrderCurryMaterialDown(
                                              item,
                                              DateFormat("yyyy.MM.dd")
                                                  .format(new DateTime.now()));
                                    },
                                    child: Icon(
                                      const IconData(0xe801,
                                          fontFamily: 'Down'),
                                      size: 20,
                                      color: Colors.amber,
                                    ),
                                  ),
                                )
                              : Container(),
                          item.getOrderMaterial != 1
                              ? Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      context
                                          .read<CurryMaterialStore>()
                                          .updateOrderCurryMaterialUp(
                                              item,
                                              DateFormat("yyyy.MM.dd")
                                                  .format(new DateTime.now()));
                                    },
                                    child: Icon(
                                      const IconData(0xe802, fontFamily: 'Up'),
                                      size: 20,
                                      color: Colors.amber,
                                    ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 40,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: TextFormField(
                                key: Key(item.getOrderMaterial.toString()),
                                initialValue: item.getMaterialName,
                                onChanged: (value) => context
                                    .read<CurryMaterialStore>()
                                    .updateCurryMaterialName(
                                      new CurryMaterial(
                                        materialName: value,
                                        id: item.getId,
                                        recipeId: recipeId,
                                        versionId: versionId,
                                      ),
                                      DateFormat("yyyy.MM.dd")
                                          .format(new DateTime.now()),
                                    ),
                                style: const TextStyle(fontSize: 15.0),
                                onTap: () => {
                                  context
                                      .read<CurryMaterialStore>()
                                      .changeReverseFlagTrue(),
                                  context
                                      .read<VersionStore>()
                                      .isTextFieldOpenFalse(),
                                },
                                decoration: const InputDecoration(
                                  hintText: 'クミン',
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: 40,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: TextFormField(
                                key: Key(item.getOrderMaterial.toString()),
                                initialValue: item.getMaterialAmount,
                                onChanged: (value) => context
                                    .read<CurryMaterialStore>()
                                    .updateCurryMaterialAmount(
                                      new CurryMaterial(
                                        materialAmount: value,
                                        id: item.getId,
                                        recipeId: recipeId,
                                        versionId: versionId,
                                      ),
                                      DateFormat("yyyy.MM.dd")
                                          .format(new DateTime.now()),
                                    ),
                                style: const TextStyle(fontSize: 15.0),
                                onTap: () => {
                                  context
                                      .read<CurryMaterialStore>()
                                      .changeReverseFlagTrue(),
                                  context
                                      .read<VersionStore>()
                                      .isTextFieldOpenFalse(),
                                },
                                decoration: const InputDecoration(
                                  hintText: '大さじ2',
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  void _showDialog(int i, CurryMaterial item, BuildContext context) => {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('削除'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('作り方' + item.getOrderMaterial.toString() + 'を削除しますか？'),
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

  void _deleteRecipe(CurryMaterial item, BuildContext context) async => {
        await context
            .read<CurryMaterialStore>()
            .deleteCurryMaterial(item.id, item.getRecipeId, item.getVersionId),
        await context.read<CurryMaterialStore>().updateOrderCurryMaterial(
            item, DateFormat("yyyy.MM.dd").format(new DateTime.now())),
        Navigator.pop(context)
      };
}
