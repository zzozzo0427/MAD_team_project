import 'package:flutter/material.dart';
import 'package:mad_real_project/map.dart';
import 'login.dart';
import 'splash.dart';

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
        '/map': (context) => MapScreen(),
      },
    );
  }
}