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
  int userRank = 0;
  int myPoints = 0;

  @override
  Future<void> onLoad() async {
    user = FirebaseAuth.instance.currentUser; // 이미 로그인된 사용자 정보 가져오기
    await fetchUserData();

    addAll([
      Background(),
      Ground(),
      bird = Bird(),
      highScore = buildHighScore(),
      score = buildScore(),
    ]);

    interval.onTick = () => add(PipeGroup());
  }

  Future<void> fetchUserData() async {
    if (user == null) return;
    final scoreDoc = await FirebaseFirestore.instance
        .collection('scores')
        .doc(user!.uid)
        .get();
    if (scoreDoc.exists) {
      highestScore = scoreDoc['highScore'] as int;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (userDoc.exists) {
      userRank = userDoc['rank'] as int;
      myPoints = userDoc['MyPoints'] as int;
    }
  }

  Future<void> updateHighScore() async {
    if (user == null) return;

    int additionalScore = bird.score - highestScore;
    if (additionalScore > 0) {
      highestScore = bird.score;

      // High score 업데이트
      await FirebaseFirestore.instance.collection('scores').doc(user!.uid).set({
        'highScore': highestScore,
      });

      // MyPoints와 rank 업데이트
      int additionalPoints = additionalScore * 5;
      myPoints += additionalPoints;
      userRank = (myPoints / 50).floor(); // rank 값 정수로 업데이트

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'MyPoints': myPoints,
        'rank': userRank,
      });
    }
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
      updateHighScore();
    }
  }
}
