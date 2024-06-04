import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:mad_real_project/game/flappy_bird_game.dart';
import 'package:mad_real_project/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mad_real_project/screens/game_over_screen.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    WidgetsFlutterBinding.ensureInitialized();
    Flame.device.fullScreen();

    final game = FlappyBirdGame();

    return Scaffold(
      body: GameWidget(
        game: game,
        initialActiveOverlays: const [MainMenuScreen.id],
        overlayBuilderMap: {
          'mainMenu': (context, _) => MainMenuScreen(game: game),
          'gameOver': (context, _) => GameOverScreen(game: game),
        },
      ),
    );
  }
}
