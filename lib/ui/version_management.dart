import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/curry_item_bloc.dart';
import '../models/curry_item.dart';

class VersionManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    final bloc = Provider.of<CurryItemBloc>(context);
    return StreamBuilder<List<CurryItem>>(
        stream: bloc.getCurryItemList,
        initialData: [],
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text('バージョン管理'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    args,
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
        });
  }
}
