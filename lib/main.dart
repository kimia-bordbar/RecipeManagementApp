import 'package:flutter/material.dart';
import 'package:recipes/src/screens/all_recipes_screen.dart';
import 'package:recipes/src/screens/new_recipes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const AllRecipesScreen(),
        '/new': (_) => const NewRecipeScreen(),
      },
    );
  }
}
