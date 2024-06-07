import 'package:flutter/material.dart';
import 'package:mad_real_project/challenge.dart';
import 'package:mad_real_project/community.dart';
import 'package:mad_real_project/game.dart';
import 'map.dart';
import 'login.dart';
import 'splash.dart';
import 'home.dart';
import 'rank.dart';
import 'profile.dart';
import 'add.dart';
import 'weather.dart';
import 'shop.dart';

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
        '/profile': (context) => ProfileScreen(),
        '/challenge': (context) => ChallengeScreen(),
        '/community': (context) => CommunityPage(),
        '/add': (context) => AddPostPage(),
        '/weather': (context) => WeatherScreen(),
        '/game': (context) => GameScreen(), // 게임 화면 라우트 추가
        '/shop': (context) => ShopScreen(),
      },
    );
  }
}
