import 'package:flutter/material.dart';

class AboutTanoshige extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AboutTanoshige(); // This tra
  }
}

class _AboutTanoshige extends StatelessWidget {
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
                    "Tanoshige",
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
                    "皆様の日々の暮らしを少しだけ、ラクに楽しくすることを目指し活動しています。\n\n"
                    "収益よりも成長、やりがいを大切にしながら、アプリ開発など様々なことに挑戦していきます。\n\n"
                    "皆様と私達の明日が楽しくありますように。",
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
