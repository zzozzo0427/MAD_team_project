import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChallengeScreen extends StatefulWidget {
  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final List<Map<String, dynamic>> challenges = [
    {'title': '일주일 담배 끊기', 'days': 7, 'points': 50},
    {'title': '한달 담배 끊기', 'days': 30, 'points': 400},
    {'title': '6개월 담배 끊기', 'days': 180, 'points': 3000},
    {'title': '1년 담배 끊기', 'days': 365, 'points': 10000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('담배 끊기 챌린지'),
      ),
      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          return ChallengeTile(challenge: challenges[index]);
        },
      ),
    );
  }
}

class ChallengeTile extends StatelessWidget {
  final Map<String, dynamic> challenge;

  ChallengeTile({required this.challenge});

  Future<void> _saveChallenge(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    CollectionReference challengesCollection = FirebaseFirestore.instance.collection('challenge');
    QuerySnapshot existingChallenge = await challengesCollection.where('uid', isEqualTo: user.uid).get();

    if (existingChallenge.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('진행 중인 챌린지가 있습니다.')),
      );
      return;
    }

    DateTime now = DateTime.now();
    DateTime overDate = now.add(Duration(days: challenge['days']));

    await challengesCollection.add({
      'uid': user.uid,
      'overDate': overDate,
      'overPoint': challenge['points'],
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${challenge['title']} 도전!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(challenge['title']),
        trailing: Icon(Icons.check_circle_outline),
        onTap: () => _saveChallenge(context),
      ),
    );
  }
}
