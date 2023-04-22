import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Wizard',
      home: const RecipeGPTApp(),
      /*localizationsDelegates:[ 
        AppLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('sv'), // Swedish
      ],*/
    );
  }
}
