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
          icon: Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
        title: Text(
          'Smoquit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.map, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userName.isNotEmpty ? userName : 'Loading...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 10),
                Text(
                  'LV. ${userPoints ~/ 50}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(
                value: (userPoints % 50) / 50,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(Icons.emoji_events, 'Rank', LeaderBoard()),
                _buildIconButton(Icons.cloud, 'Weather', WeatherScreen()),
                _buildIconButton(Icons.shop, 'Shop', ShopScreen()),
              ],
            ),
          ],
        ),
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
                Navigator.pushNamed(context, '/game');
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

  Widget _buildIconButton(IconData icon, String label, Widget screen) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(), backgroundColor: Colors.green,
            padding: EdgeInsets.all(15),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}