import 'package:flutter/material.dart';

class VersionManagement extends StatefulWidget {
  VersionManagement({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _VersionManagementState createState() => _VersionManagementState();
}

class _VersionManagementState extends State<VersionManagement> {
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
        title: Text('バージョン管理'),
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
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              size: 40,
            ),
            title: Text(
              'バージョン管理',
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
              '作り方',
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
