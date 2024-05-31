import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _textController = TextEditingController();

  void _submitPost() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _textController.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('post').add({
      'name': currentUser.displayName ?? 'Anonymous',
      'context': _textController.text,
      'likes': 0,
      'uid': currentUser.uid,
      'date': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final String profileImageUrl = currentUser?.photoURL ?? 'https://www.example.com/default_profile_image.png'; // 기본 이미지 URL로 대체

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('New Post'),
        actions: [
          TextButton(
            onPressed: _submitPost,
            child: Text(
              '업로드',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profileImageUrl),
                  radius: 24,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'What\'s happening?',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.green[50],
    );
  }
}
