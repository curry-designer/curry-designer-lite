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
        child: _HowToMakeList(
            recipeId: versionMap[currentVersion].getRecipeId,
            versionId: currentVersion),
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
        List<HowToMake> howToMakeList = snapshot.data;
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          height: (howToMakeList.length * 300).toDouble(),
          child: ReorderableListView(
            padding: EdgeInsets.all(10.0),
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                // removing the item at oldIndex will shorten the list by 1.
                newIndex -= 1;
              }
              final HowToMake howToMake = howToMakeList.removeAt(oldIndex);

              context
                  .read<HowToMakeStore>()
                  .insertNewIndex(newIndex, howToMake, howToMakeList);
            },
            children: howToMakeList.map(
              (HowToMake howToMake) {
                return TextFormField(
                  key: Key(howToMake.getOrderHowToMake.toString()),
                  initialValue: howToMake.getHowToMake,
                  onChanged: (value) =>
                      context.read<HowToMakeStore>().updateHowToMake(
                            new HowToMake(
                              howToMake: value,
                              id: howToMake.getId,
                              recipeId: howToMake.getRecipeId,
                              versionId: howToMake.getVersionId,
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
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
