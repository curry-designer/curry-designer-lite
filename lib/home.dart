import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  var curryList = [
    'バターチキンカレー',
    'カシューナッツのチーズカレー',
    'ほうれん草のカレー',
    'マトンカレー',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(10, 17, 10, 1),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "レシピ一覧",
                  style: TextStyle(fontSize: 40.0),
                ),
              )),
          new Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, i) {
                final item = curryList[i];
                return Slidable(
                  key: Key(item),
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: Card(
                        child: ListTile(
                      leading: Icon(
                        IconData(0xe800, fontFamily: 'Curry'),
                        color: Color.fromRGBO(105, 105, 105, 1.0),
                        size: 40,
                      ),
                      title: Text(
                        item,
                        style: TextStyle(fontSize: 20.0),
                      ),
                      subtitle: Text("version: 50"),
                    )),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => _showDialog(i),
                    ),
                  ],
                );
              },
              itemCount: curryList.length,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
//    onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    ); // This tra
  }

  void _showDialog(int i) => {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('削除'),
                content: Text('このレシピを削除してもよろしいでしょうか？'),
                actions: <Widget>[
                  FlatButton(
                    child: Text("CANCEL"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () => _deleteRecipe(i),
                  ),
                ],
              );
            })
      };

  void _deleteRecipe(int i) => {
        setState(() {
          curryList.removeAt(i);
          Navigator.pop(context);
        })
      };
}
