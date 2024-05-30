import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mad_real_project/main.dart';
import 'package:mad_real_project/profile.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'rank.dart';

class HomeScreen extends StatefulWidget {
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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userName = userDoc['Name'];
        userPoints = userDoc['MyPoints'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // 상단바 배경색을 녹색으로 설정
        leading: IconButton(
          icon: Icon(Icons.person, color: Colors.black), // 프로필 아이콘을 왼쪽에 배치
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0), // 아이콘에 직접 padding 적용
        ),
        title: Text(
          'Smoquit',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold, // 글자를 bold로 설정
          ),
        ),
        centerTitle: true, // 타이틀을 가운데로 정렬
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black), // 세팅 아이콘을 오른쪽에 배치
            onPressed: () {
              // Settings button action
            },
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0), // 아이콘에 직접 padding 적용
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white, // 원하는 배경색으로 설정
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
                    'assets/my_lung.json', // Lottie 애니메이션 파일 경로
                    fit: BoxFit.contain, // 애니메이션이 잘리지 않도록 조정
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
                  value: (userPoints % 50) / 50, // MyPoints에서 50 나눈 값의 비율
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeaderBoard()),
                );
              },
              child: Text(
                'Rank',
                style: TextStyle(color: Colors.black), // 글자 색상을 검은색으로 설정
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // 배경 색상을 흰색으로 설정
                side: BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // 동그란 모양으로 설정
                ),
              ),
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
                icon: Icon(Icons.group),
                label: 'Community',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Map',
              ),
            ],
            currentIndex: navBarModel.currentIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              navBarModel.setCurrentIndex(index);
              if (index == 3) {
                // map 아이콘 인덱스일 때
                Navigator.pushNamed(context, '/map');
              }
            },
          );
        },
      ),
    );
  }
}
