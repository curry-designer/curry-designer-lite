import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MaterialNoteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MaterialNoteWidget();
  }
}

class _MaterialNoteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        ));
  }
}
