import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/curry_item.dart';
import '../blocs/curry_item_list_bloc.dart';
import '../models/curry_item_action_enum.dart';

class RegisterRecipeForm extends StatefulWidget {
  RegisterRecipeForm({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RegisterRecipeFormState createState() => _RegisterRecipeFormState();
}

class _RegisterRecipeFormState extends State<RegisterRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  String _recipeName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onSaved: (String value) {
                      this._recipeName = value;
                    },
                  ),
                  Consumer<CurryItemListBloc>(
                    builder: (_, bloc, child) {
                      return RaisedButton(
                        onPressed: () => _register(bloc),
                        child: Text('登録'),
                      );
                    },
                  ),
                ],
              )),
        )); // This tra
  }

  void _register(bloc) {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      bloc.curryItemListListener(
        CurryItemEvent(
            CurryItem(_recipeName, 1, CurryItemActionEnum.create), null),
      );
      Navigator.pop(context);
    }
  }
}
