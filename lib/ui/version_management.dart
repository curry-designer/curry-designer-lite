import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/stores/recipe_store.dart';
import 'package:currydesignerlite/stores/version_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';

class VersionManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<VersionStore>(
        create: (_) => VersionStore(),
      )
    ], child: _VersionManagement());
  }
}

class _VersionManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    final bloc = Provider.of<VersionStore>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.home,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/");
            }),
        title: Text('バージョン管理'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<List<Version>>(
                future: bloc.fetchVersions(recipeId: args),
                builder: (context, AsyncSnapshot<List<Version>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return DropdownButton(
                    hint: Text('version: ' + snapshot.data[0].getId.toString()),
                    value: snapshot.data[0].getId,
                    items: snapshot.data.map((item) {
                      return DropdownMenuItem(
                        child: Text('version: ' + item.getId.toString()),
                        value: item.getId,
                      );
                    }).toList(),
                    onChanged: (value) {
                      bloc.setDropdownVersion(value);
                    },
                  );
                })
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        onTap: (int index) {
          Navigator.pushNamed(context, '/material-note');
        },
      ),
    );
  }
}
