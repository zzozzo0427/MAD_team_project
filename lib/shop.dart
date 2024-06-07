import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:mad_real_project/home.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  User? user;
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    fetchUserHighScore();
  }

  Future<void> fetchUserHighScore() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('scores')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        setState(() {
          highScore = doc['highScore'] as int;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                if (index == 0 || highScore >= _scoreThreshold(index)) {
                  _updateHomeLottie(index + 1);
                }
              },
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildLottieWidget(index),
                      ),
                      SizedBox(height: 8), // 위 여백 추가
                      Text(
                        'Score: ${_scoreThreshold(index)}',
                        style: TextStyle(
                          color: highScore >= _scoreThreshold(index)
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8), // 아래 여백 추가
                    ],
                  ),
                  if (!(index == 0 || highScore >= _scoreThreshold(index)))
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLottieWidget(int index) {
    final lottieFiles = [
      'assets/my_1.json',
      'assets/my_2.json',
      'assets/my_3.json',
      'assets/my_4.json',
      'assets/my_5.json',
    ];

    final isUnlocked = index == 0 || highScore >= _scoreThreshold(index);
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.2,
      child: Lottie.asset(lottieFiles[index]),
    );
  }

  int _scoreThreshold(int index) {
    switch (index) {
      case 1:
        return 2;
      case 2:
        return 5;
      case 3:
        return 7;
      case 4:
        return 10;
      default:
        return 0;
    }
  }

  Future<void> _updateHomeLottie(int lottieIndex) async {
    final lottieFiles = [
      'assets/my_1.json',
      'assets/my_2.json',
      'assets/my_3.json',
      'assets/my_4.json',
      'assets/my_5.json',
    ];

    // Update the Lottie animation used in the home screen
    HomeScreen.currentLottie = lottieFiles[lottieIndex - 1];

    // Navigate back to the home screen
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }
}
