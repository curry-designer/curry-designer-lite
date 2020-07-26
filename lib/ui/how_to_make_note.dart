import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/models/how_to_make.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:currydesignerlite/stores/how_to_make_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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

    FocusScopeNode currentFocus = FocusScope.of(context);

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
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "作り方" + item.getOrderHowToMake.toString(),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(0.0),
                  child: TextFormField(
                    key: Key(item.getOrderHowToMake.toString()),
                    initialValue: item.getHowToMake,
                    onChanged: (value) => context
                        .read<HowToMakeStore>()
                        .updateHowToMake(
                          new HowToMake(
                            howToMake: value,
                            id: item.getId,
                            recipeId: item.getRecipeId,
                            versionId: item.getVersionId,
                          ),
                          DateFormat("yyyy.MM.dd").format(new DateTime.now()),
                        ),
                    style: const TextStyle(fontSize: 15.0),
                    maxLines: 5,
                    onTap: () => {
                      context.read<HowToMakeStore>().changeReverseFlagTrue(),
                      context.read<VersionStore>().isTextFieldOpenFalse(),
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
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
}
