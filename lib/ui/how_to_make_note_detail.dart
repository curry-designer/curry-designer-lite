import 'package:currydesignerlite/models/how_to_make.dart';
import 'package:currydesignerlite/stores/how_to_make_store.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    final currentFocus = FocusScope.of(context);

    final args =
        ModalRoute.of(context).settings.arguments as Map<dynamic, dynamic>;
    final id = args['id'] as int;
    final recipeId = args['recipeId'] as int;
    final versionId = args['versionId'] as int;
    final orderHowToMake = args['orderHowToMake'] as int;
    final howToMake = args['howToMake'] as String;

    return GestureDetector(
      // 入力キーボードをどこを押しても閉じれるようにする。
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('作り方${orderHowToMake.toString()}'),
        ),
        body: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width * 0.88,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    child: const Text('※自動保存'),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            key: Key(orderHowToMake.toString()),
                            initialValue: howToMake,
                            onChanged: (value) =>
                                context.read<HowToMakeStore>().updateHowToMake(
                                      HowToMake(
                                        howToMake: value,
                                        id: id,
                                        recipeId: recipeId,
                                        versionId: versionId,
                                        orderHowToMake: orderHowToMake,
                                      ),
                                      DateFormat('yyyy.MM.dd HH:mm:ss')
                                          .format(DateTime.now()),
                                    ),
                            style: const TextStyle(fontSize: 15),
                            maxLength: 100,
                            maxLines: 6,
                            onTap: () => {
                              context
                                  .read<HowToMakeStore>()
                                  .changeReverseFlagTrue(),
                              context
                                  .read<VersionStore>()
                                  .isTextFieldOpenFalse(),
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 15),
                            child: ElevatedButton(
                              onPressed: () => {
                                {Navigator.pop(context)},
                              },
                              child: const Text(
                                '更新',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
