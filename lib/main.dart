import 'package:flutter/material.dart';
import 'ui/home.dart';
import 'ui/register_recipe_form.dart';
import 'ui/material_note.dart';
import 'ui/note.dart';
import 'ui/how_to_make_note_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.amberAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
//        fontFamily: 'Cursive', //TODO:Fontどうするか決めたい
      ),
      // MaterialApp contains our top-level Navigator
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => Home(title: 'Curry Note Lite'),
        '/note': (BuildContext context) => Note(),
        '/register-recipe': (BuildContext context) => RegisterRecipeForm(),
        '/material-note': (BuildContext context) => TextWidget(),
        '/how_to_make_note_detail': (BuildContext context) =>
            HowToMakeNoteDetail(),
      },
    );
  }
}
