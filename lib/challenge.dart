import 'package:flutter/material.dart';

class ChallengeScreen extends StatefulWidget {
  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final List<String> challenges = [
    '일주일 담배 끊기',
    '한달 담배 끊기',
    '6개월 담배 끊기',
    '1년 담배 끊기'
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
  final String challenge;

  ChallengeTile({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(challenge),
        trailing: Icon(Icons.check_circle_outline),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$challenge 도전!')),
          );
        },
      ),
    );
  }
}
