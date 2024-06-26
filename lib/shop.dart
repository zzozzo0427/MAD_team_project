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
  int myPoints = 0;

  @override
  void initState() {
    super.initState();
    fetchUserPoints();
  }

  Future<void> fetchUserPoints() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          myPoints = userDoc['MyPoints'] as int;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int userRank = myPoints ~/ 50;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shop'),
            Text(
              'My Rank: $userRank',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                if (_isLottieUnlocked(index)) {
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
                      SizedBox(height: 8),
                      Text(
                        'Rank: ${_rankThreshold(index)}',
                        style: TextStyle(
                          color: _isLottieUnlocked(index)
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                  if (!_isLottieUnlocked(index))
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

    final isUnlocked = _isLottieUnlocked(index);
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.2,
      child: Lottie.asset(lottieFiles[index]),
    );
  }

  bool _isLottieUnlocked(int index) {
    int userRank = myPoints ~/ 50;
    return index == 0 || userRank >= _rankThreshold(index);
  }

  int _rankThreshold(int index) {
    switch (index) {
      case 1:
        return 10;
      case 2:
        return 20;
      case 3:
        return 30;
      case 4:
        return 40;
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

    HomeScreen.currentLottie = lottieFiles[lottieIndex - 1];

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }
}
