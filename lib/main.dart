import 'package:currydesignerlite/stores/how_to_make_store.dart';
import 'package:currydesignerlite/ui/setting.dart';
import 'package:currydesignerlite/ui/setting_detail/about_curry_designer_lite.dart';
import 'package:currydesignerlite/ui/setting_detail/about_tanoshige.dart';
import 'package:currydesignerlite/ui/setting_detail/terms_of_use.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/home.dart';
import 'ui/how_to_make_note_detail.dart';
import 'ui/note.dart';
import 'ui/register_recipe_form.dart';
import 'ui/version_filter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      // 作り方の変更をページ跨ぎで行いため、MaterialAppの上でProviderを定義する。
      ChangeNotifierProvider<HowToMakeStore>(
        create: (context) => HowToMakeStore(),
      ),
    ], child: _MyApp());
  }
}

class _MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curry Note',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.amberAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // MaterialApp contains our top-level Navigator
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const Home(title: 'Curry Note'),
        '/setting': (BuildContext context) => Setting(),
        '/note': (BuildContext context) => Note(),
        '/register-recipe': (BuildContext context) => RegisterRecipeForm(),
        '/how_to_make_note_detail': (BuildContext context) =>
            HowToMakeNoteDetail(),
        '/about-curry-designer-lite': (BuildContext context) =>
            AboutCurryDesignerLite(),
        '/about-tanoshige': (BuildContext context) => AboutTanoshige(),
        '/terms-of-use': (BuildContext context) => TermsOfUse(),
        '/version-filter': (BuildContext context) => VersionFilter(),
      },
    );
  }
}
