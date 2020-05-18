import 'package:flutter/material.dart';
import 'ui/home.dart';
import 'ui/register_recipe_form.dart';
import './models/curry_item.dart';
import 'package:provider/provider.dart';
import './blocs/curry_item_list_bloc.dart';
import './models/curry_item_action_enum.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<CurryItemListBloc>(
      create: (_) => CurryItemListBloc(),
      dispose: (_, bloc) => bloc.dispose(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          accentColor: Colors.amberAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // MaterialApp contains our top-level Navigator
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => Home(title: 'Curry Note Lite'),
          '/register-recipe': (BuildContext context) => RegisterRecipeForm(),
        },
      ),
    );
  }
}
