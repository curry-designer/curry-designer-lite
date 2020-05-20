import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/curry_item.dart';
import '../blocs/curry_item_bloc.dart';
import 'package:intl/intl.dart';

class RegisterRecipeForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
                      child: StreamBuilder<String>(
                          stream: bloc.getCurryRecipeName,
                          initialData: "",
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return Column(
                              children: <Widget>[
                                TextFormField(
                                  maxLength: 100,
                                  decoration: const InputDecoration(
                                    hintText: 'バターチキンカレー etc...',
                                    labelText: 'レシピ名',
                                  ),
                                  validator: (String value) {
                                    return value.isEmpty
                                        ? 'レシピ名を入力してください。'
                                        : null;
                                  },
                                  onChanged: (String value) {
                                    bloc.registerCurryRecipeName(value);
                                  },
                                ),
                                Consumer<CurryItemBloc>(
                                  builder: (_, bloc, child) {
                                    return RaisedButton(
                                      onPressed: () =>
                                          _register(snapshot.data, context),
                                      child: Text('登録'),
                                    );
                                  },
                                ),
                              ],
                            );
                          }));
                }))); // This tra
  }

  void _register(String data, context) {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      Provider.of<CurryItemBloc>(context, listen: false)
          .createCurryItem(CurryItem(
        id: null,
        name: data,
        latestVersion: DateFormat("yyyy.MM.dd").format(new DateTime.now()),
        starCount: 4,
      ));
      Navigator.pop(context);
    }
  }
}
