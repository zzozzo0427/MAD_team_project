import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:mad_real_project/game/assets.dart';
import 'package:mad_real_project/game/flappy_bird_game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Background();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load(Assets.backgorund);
    size = gameRef.size;
    sprite = Sprite(background);
  }
}
