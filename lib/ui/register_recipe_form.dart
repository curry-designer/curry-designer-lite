import 'package:currydesignerlite/stores/curry_item_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/curry_item.dart';
import 'package:intl/intl.dart';

class RegisterRecipeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CurryItemStore>(
        create: (_) => CurryItemStore(), child: _RegisterRecipeForm());
  }
}

class _RegisterRecipeForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CurryItemStore>(context);
    bloc.fetchCurryItems();
    return ChangeNotifierProvider<CurryItemStore>(
      create: (_) => CurryItemStore(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('レシピの登録'),
          ),
          body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    maxLength: 100,
                    decoration: const InputDecoration(
                      hintText: 'バターチキンカレー etc...',
                      labelText: 'レシピ名',
                    ),
                    validator: (String value) {
                      return value.isEmpty ? 'レシピ名を入力してください。' : null;
                    },
                    onChanged: (String value) {
                      bloc.registerCurryRecipeName(value);
                    },
                  ),
                  RaisedButton(
                    onPressed: () =>
                        _register(bloc.getCurryRecipeName, context),
                    child: Text('登録'),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _register(String data, context) {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      Provider.of<CurryItemStore>(context, listen: false)
          .createCurryItem(CurryItem(
        id: null,
        name: data,
        latestUpdateDate: DateFormat("yyyy.MM.dd").format(new DateTime.now()),
        starCount: 4,
      ));
      Navigator.pushNamed(context, "/");
    }
  }
}
