import 'package:currydesignerlite/models/how_to_make.dart';
import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:currydesignerlite/stores/how_to_make_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import 'package:intl/intl.dart';

class HowToMakeNoteDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<VersionStore>(
        create: (context) => VersionStore(),
      ),
      ChangeNotifierProvider<HowToMakeStore>(
        create: (context) => HowToMakeStore(),
      )
    ], child: _HowToMakeNoteDetail());
  }
}

class _HowToMakeNoteDetail extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // 入力キーボードをどこを押しても閉じれるようにするための現在のフォーカスを定義。
    FocusScopeNode currentFocus = FocusScope.of(context);

    Map args = ModalRoute.of(context).settings.arguments;
    final id = args["id"];
    final recipeId = args["recipeId"];
    final versionId = args["versionId"];
    final orderHowToMake = args["orderHowToMake"];
    final howToMake = args["howToMake"];

    return GestureDetector(
      // 入力キーボードをどこを押しても閉じれるようにする。
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('作り方' + orderHowToMake.toString()),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: Key(orderHowToMake.toString()),
                    initialValue: howToMake,
                    onChanged: (value) => context
                        .read<HowToMakeStore>()
                        .updateHowToMake(
                          new HowToMake(
                            howToMake: value,
                            id: id,
                            recipeId: recipeId,
                            versionId: versionId,
                            orderHowToMake: orderHowToMake,
                          ),
                          DateFormat("yyyy.MM.dd").format(new DateTime.now()),
                        ),
                    style: const TextStyle(fontSize: 15.0),
                    maxLength: 100,
                    maxLines: 6,
                    onTap: () => {
                      context.read<HowToMakeStore>().changeReverseFlagTrue(),
                      context.read<VersionStore>().isTextFieldOpenFalse(),
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
