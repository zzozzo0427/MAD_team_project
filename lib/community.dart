import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Community Board",
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text("Community Board"),
          elevation: 4.0,
        ),
        body: PostList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add'); // add.dart로 이동
          },
          child: Icon(Icons.create),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}

class PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('post').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final posts = snapshot.data!.docs;
        posts.sort((a, b) {
          final likesA = (a.data() as Map<String, dynamic>)['likes'] ?? 0;
          final likesB = (b.data() as Map<String, dynamic>)['likes'] ?? 0;
          return likesB.compareTo(likesA);
        });        
        List<Widget> postWidgets = [];
        for (var post in posts) {
          final postData = post.data() as Map<String, dynamic>;
          final postWidget = PostItem(
            postId: post.id,
            name: postData['name'],
            p_context: postData['context'],
            likes: postData['likes'] ?? 0,
            uid: postData['uid'],
          );
          postWidgets.add(postWidget);
        }
        return ListView(
          children: postWidgets,
        );
      },
    );
  }
}

class PostItem extends StatefulWidget {
  final String postId;
  final String name;
  final String p_context;
  final int likes;
  final String uid;

  PostItem({
    required this.postId,
    required this.name,
    required this.p_context,
    required this.likes,
    required this.uid,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isLiked = false;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
    checkIfLiked();
  }

  void checkIfLiked() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final likeDoc = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.postId)
          .collection('likes')
          .doc(currentUser.uid)
          .get();

      setState(() {
        isLiked = likeDoc.exists;
      });
    }
  }

  void toggleLike() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final likeRef = FirebaseFirestore.instance
        .collection('post')
        .doc(widget.postId)
        .collection('likes')
        .doc(currentUser.uid);

    if (isLiked) {
      await likeRef.delete();
      FirebaseFirestore.instance.collection('post').doc(widget.postId).update({'likes': FieldValue.increment(-1)});
      setState(() {
        likeCount -= 1;
        isLiked = false;
      });
    } else {
      await likeRef.set({});
      FirebaseFirestore.instance.collection('post').doc(widget.postId).update({'likes': FieldValue.increment(1)});
      setState(() {
        likeCount += 1;
        isLiked = true;
      });
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: Text('예'),
              onPressed: () {
                deletePost();
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  void deletePost() {
    FirebaseFirestore.instance.collection('post').doc(widget.postId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(widget.name[0], style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    widget.p_context,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: toggleLike,
                      ),
                      Text('$likeCount'),
                      if (currentUser != null && currentUser.uid == widget.uid) ...[
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.grey),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModifyPostPage(postId: widget.postId),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey),
                          onPressed: () {
                            _showDeleteDialog(context);
                          },
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModifyPostPage extends StatefulWidget {
  final String postId;

  ModifyPostPage({required this.postId});

  @override
  _ModifyPostPageState createState() => _ModifyPostPageState();
}

class _ModifyPostPageState extends State<ModifyPostPage> {
  final TextEditingController _textController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  void _loadPostData() async {
    final postDoc = await FirebaseFirestore.instance.collection('post').doc(widget.postId).get();
    if (postDoc.exists) {
      setState(() {
        _textController.text = postDoc['context'];
        isLoading = false;
      });
    }
  }

  void _updatePost() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _textController.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('post').doc(widget.postId).update({
      'context': _textController.text,
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
        title: Text('Modify Post'),
        actions: [
          TextButton(
            onPressed: _updatePost,
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
