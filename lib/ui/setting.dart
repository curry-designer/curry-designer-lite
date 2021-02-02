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
          icon: const Icon(
            Icons.home,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        title: const Text('設定'),
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
                    'About',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/about-curry-designer-lite');
                  },
                  child: SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          'Curry Designer Liteについて',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/about-tanoshige');
                  },
                  child: SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          'Tanoshigeについて',
                          style: TextStyle(fontSize: 16),
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
                  child: const Text(
                    '共有',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
//                  print('onTap called.');
                  },
                  child: SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          'このアプリを友達に教える',
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
//                  print('onTap called.');
                  },
                  child: SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          'このアプリを評価する',
                          style: TextStyle(fontSize: 16),
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
                  child: const Text(
                    'その他',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
//              GestureDetector(
//                onTap: () {
////                  print('onTap called.');
//                },
//                child: Container(
//                  color: Colors.white,
//                  height: 35,
//                  width: MediaQuery.of(context).size.width * 0.90,
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text(
//                        'ライセンス',
//                        style: TextStyle(fontSize: 16.0),
//                      ),
//                      Icon(Icons.chevron_right)
//                    ],
//                  ),
//                ),
//              ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/terms-of-use');
                  },
                  child: SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          '利用規約',
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
