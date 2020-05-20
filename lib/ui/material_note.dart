import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class TextWidget extends StatefulWidget {
  TextWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('材料'),
      ),

      body: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '材料をメモ',
            ),

            maxLines: 20,
          ),
        ],
      )
    );
  }
}