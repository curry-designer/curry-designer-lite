import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Setting(); // This tra
  }
}

class _Setting extends StatelessWidget {
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
          },
        ),
        title: Text('設定'),
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
                    "About",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/about-curry-designer-lite");
                  },
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Curry Designer Liteについて",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/about-tanoshige");
                  },
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Tanoshigeについて",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black12,
                  height: 50,
                  thickness: 2,
                  indent: MediaQuery.of(context).size.width * 0.05,
                  endIndent: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Text(
                    "共有",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
//                  print("onTap called.");
                  },
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "このアプリを友達に教える",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
//                  print("onTap called.");
                  },
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "このアプリを評価する",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black12,
                  height: 50,
                  thickness: 2,
                  indent: MediaQuery.of(context).size.width * 0.05,
                  endIndent: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Text(
                    "その他",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
//              GestureDetector(
//                onTap: () {
////                  print("onTap called.");
//                },
//                child: Container(
//                  color: Colors.white,
//                  height: 35,
//                  width: MediaQuery.of(context).size.width * 0.90,
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text(
//                        "ライセンス",
//                        style: TextStyle(fontSize: 16.0),
//                      ),
//                      Icon(Icons.chevron_right)
//                    ],
//                  ),
//                ),
//              ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/terms-of-use");
                  },
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "利用規約",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
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
