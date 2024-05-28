import 'package:flutter/material.dart';
import 'map.dart';
import 'login.dart';
import 'splash.dart';
import 'home.dart';
import 'rank.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smoquit',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/map': (context) => MapScreen(),
        '/rank': (context) => LeaderBoard(),
      },
    );
  }
}
