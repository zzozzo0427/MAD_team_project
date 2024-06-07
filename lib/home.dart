import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mad_real_project/main.dart';
import 'package:mad_real_project/map.dart';
import 'package:mad_real_project/profile.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'rank.dart';
import 'weather.dart';
import 'shop.dart';

class HomeScreen extends StatefulWidget {
  static String currentLottie = 'assets/my_1.json';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  int userPoints = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userName = userDoc['Name'];
        userPoints = userDoc['MyPoints'];
      });
    }
  }

  void updateLottieAnimation(String lottiePath) {
    setState(() {
      HomeScreen.currentLottie = lottiePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.person, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        ),
        title: Text(
          'Smoquit',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.map, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
              );
            },
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Settings button action
            },
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      userName.isNotEmpty ? userName : 'Loading...',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Lottie.asset(
                    HomeScreen.currentLottie,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'LV. ${userPoints ~/ 50}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 20),
                LinearProgressIndicator(
                  value: (userPoints % 50) / 50,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            right: 20,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LeaderBoard()),
                    );
                  },
                  child: Icon(
                    Icons.emoji_events,
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 10), // 여백 추가
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WeatherScreen()),
                    );
                  },
                  child: Icon(
                    Icons.cloud, // 날씨 아이콘
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShopScreen()),
                    );
                  },
                  child: Icon(
                    Icons.shop, // 상점 아이콘
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<NavBarModel>(
        builder: (context, navBarModel, child) {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset),
                label: 'Game',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_mma),
                label: 'Challenge',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Community',
              ),
            ],
            currentIndex: navBarModel.currentIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              navBarModel.setCurrentIndex(index);
              if (index == 1) {
                Navigator.pushNamed(context, '/game'); // 게임 화면으로 이동
              }
              if (index == 2) {
                Navigator.pushNamed(context, '/challenge');
              }
              if (index == 3) {
                Navigator.pushNamed(context, '/community');
              }
            },
          );
        },
      ),
    );
  }
}
