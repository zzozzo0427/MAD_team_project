import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:mad_real_project/components/background.dart';
import 'package:mad_real_project/components/bird.dart';
import 'package:mad_real_project/components/ground.dart';
import 'package:mad_real_project/components/pipe_group.dart';
import 'package:mad_real_project/game/configuration.dart';
import 'package:flutter/painting.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  FlappyBirdGame();

  late Bird bird;
  Timer interval = Timer(Config.pipeInterval, repeat: true);
  bool isHit = false;
  late TextComponent score;
  late TextComponent highScore;
  User? user;
  int highestScore = 0;

  @override
  Future<void> onLoad() async {
    user = FirebaseAuth.instance.currentUser; // 이미 로그인된 사용자 정보 가져오기
    await fetchHighScore();

    addAll([
      Background(),
      Ground(),
      bird = Bird(),
      highScore = buildHighScore(),
      score = buildScore(),
    ]);

    interval.onTick = () => add(PipeGroup());
  }

  Future<void> fetchHighScore() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('scores')
        .doc(user!.uid)
        .get();
    if (doc.exists) {
      highestScore = doc['highScore'] as int;
    }
  }

  Future<void> updateHighScore() async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('scores').doc(user!.uid).set({
      'highScore': highestScore,
    });
  }

  TextComponent buildScore() {
    return TextComponent(
      position: Vector2(size.x / 2, size.y / 2 * 0.25),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40,
          fontFamily: 'Game',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TextComponent buildHighScore() {
    return TextComponent(
      position: Vector2(size.x / 2, size.y / 2 * 0.15),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'Game',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void onTap() {
    bird.fly();
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
    score.text = 'Score: ${bird.score}';
    highScore.text = 'High Score: $highestScore';

    if (bird.score > highestScore) {
      highestScore = bird.score;
      updateHighScore();
    }
  }
}
