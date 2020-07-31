import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class TextStore with ChangeNotifier {
  final materialList = [];
}

class MaterialNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TextStore>(
        create: (context) => TextStore(), child: _MaterialNote());
  }
}

class _MaterialNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.home,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/");
            }),
        title: Text('材料'),
      ),
      body: TextWidget(),
    );
  }
}

class TextWidget extends StatefulWidget {
  TextWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List<String> added = [];
  String currentText = "";

  var suggestions = ['クミン', 'コリアンダー', 'ターメリック', 'カイエンペッパー', 'ガラムマサラ',
  'cumin', 'coriander'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
                SimpleAutoCompleteTextField(
          key: key,
          suggestions: suggestions,
          clearOnSubmit: true,
          textSubmitted: (text) => setState(() {
            if (text != "") {
              added.add(text);
            }
          }),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '材料をメモ',
          ),
        ),
        Text('ここにリストだしたい'),
            LimitedBox(
              maxHeight: 100,
              child:
            ListView.builder(
              itemCount: added.length,
              itemBuilder: (BuildContext context,int index){
                return Text(added[index]);
            }))
            ,

      ],
    ));
  }
}