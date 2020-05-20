import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/curry_item.dart';
import '../blocs/curry_item_bloc.dart';
import 'package:intl/intl.dart';

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
    final bloc = Provider.of<CurryItemBloc>(context);
    bloc.fetchCurryItems();
    return Scaffold(
        appBar: AppBar(
          title: Text('レシピの登録'),
        ),
        body: Form(
            key: _formKey,
            child: StreamBuilder<List<CurryItem>>(
                stream: bloc.getCurryItemList,
                builder: (context, AsyncSnapshot<List<CurryItem>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
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
                          Consumer<CurryItemBloc>(
                            builder: (_, bloc, child) {
                              return RaisedButton(
                                onPressed: () =>
                                    _register(snapshot.data.length),
                                child: Text('登録'),
                              );
                            },
                          ),
                        ],
                      ));
                }))); // This tra
  }

  void _register(int length) {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      int len = length == null ? 1 : length + 1;
      Provider.of<CurryItemBloc>(context, listen: false)
          .createCurryItem(CurryItem(
        id: len,
        name: _recipeName,
        latestVersion: DateFormat("yyyy.MM.dd").format(new DateTime.now()),
        starCount: 4,
      ));
      Navigator.pop(context);
    }
  }
}
