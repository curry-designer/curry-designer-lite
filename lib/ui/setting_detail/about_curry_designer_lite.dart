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
        title: Text('Curry Designer Liteについて'),
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
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    "Curry Designer Lite",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    "本アプリは"
                    "「理想のカレーを日々探究する皆様のお役に立てるようなメモアプリ」"
                    "を目指しリリースいたしました。\n\n"
                    "皆様のカレー作りに対する工夫のメモや振り返りが、"
                    "ラクに楽しく行えるようになったら嬉しいです。\n\n"
                    "何か不備などございましたらアプリストアにてコメントいただけますと幸いです。\n",
                    style: TextStyle(fontSize: 16.0),
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
