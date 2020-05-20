import 'package:flutter/material.dart';
import 'ui/home.dart';
import 'ui/register_recipe_form.dart';
import 'ui/version_management.dart';
import 'ui/material_note.dart';
import 'package:provider/provider.dart';
import './blocs/curry_item_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<CurryItemBloc>(
      create: (_) => CurryItemBloc(),
      dispose: (_, bloc) => bloc.dispose(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          accentColor: Colors.amberAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Cursive',//TODO:Fontどうするか決めたい
          
        ),
        // MaterialApp contains our top-level Navigator
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => Home(title: 'Curry Note Lite'),
          '/register-recipe': (BuildContext context) => RegisterRecipeForm(),
          '/version-management': (BuildContext context) => VersionManagement(),
          '/material-note':(BuildContext context) => TextWidget(),
        },
      ),
    );
  }
}
