import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              size: 40,
            ),
            title: Text(
              'メニューリスト',
              style: TextStyle(fontSize: 11),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              size: 40,
            ),
            title: Text(
              'ヒストリ',
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              const IconData(0xe800, fontFamily: 'Material'),
              color: Color.fromRGBO(105, 105, 105, 1.0),
              size: 40,
            ),
            title: Text(
              '材料',
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              const IconData(0xe800, fontFamily: 'Knife'),
              color: Color.fromRGBO(105, 105, 105, 1.0),
              size: 40,
            ),
            title: Text(
              '手順',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
//        currentIndex: _selectedIndex,
//        selectedItemColor: Colors.amber[800],
//        onTap: _onItemTapped,
      ),
    );
  }
}
