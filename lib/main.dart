import 'package:flutter/material.dart';
import 'package:flutter_cocktails/login_page.dart';
import 'package:flutter_cocktails/home_page.dart';
import 'package:flutter_cocktails/search_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktails Explorer',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 218, 141, 239),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => CocktailHomePage(),
        '/search': (context) => SearchScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
