import 'package:flutter/material.dart';

class AboutCurryDesignerLite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AboutCurryDesignerLite(); // This tra
  }
}

class _AboutCurryDesignerLite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curry Noteについて'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    'Curry Note',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '本アプリは'
                    '「理想のカレーを日々探究する皆様のお役に立てるようなメモアプリ」'
                    'を目指しリリースいたしました。\n\n'
                    '皆様のカレー作りに対する工夫のメモや振り返りが、'
                    'ラクに楽しく行えるようになったら嬉しいです。\n\n'
                    '何か不備・要望などございましたら「アプリストア」や「お問い合わせ」にてコメントいただけますと幸いです。\n',
                    style: TextStyle(fontSize: 16),
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
