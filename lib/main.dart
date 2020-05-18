import 'package:flutter/material.dart';
import 'ui/home.dart';
import 'ui/register_recipe_form.dart';

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
      ),
      // MaterialApp contains our top-level Navigator
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => Home(title: 'Curry Designer Lite'),
        '/register-recipe': (BuildContext context) => RegisterRecipeForm(),
      },
    );
  }
}
