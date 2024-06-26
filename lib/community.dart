import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  bool _sortByLikes = true;

  void _toggleSortOrder() {
    setState(() {
      _sortByLikes = !_sortByLikes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Community Board",
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Community Board"),
          elevation: 4.0,
          actions: [
            IconButton(
              icon: Icon(
                _sortByLikes ? Icons.favorite : Icons.star,
                color: _sortByLikes ? Colors.red : Colors.yellow,
              ),
              onPressed: _toggleSortOrder,
            ),
          ],
        ),
        body: PostList(sortByLikes: _sortByLikes),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
          child: Icon(Icons.create),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}

class PostList extends StatefulWidget {
  final bool sortByLikes;

  PostList({required this.sortByLikes});

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late Stream<QuerySnapshot> _postStream;

  @override
  void initState() {
    super.initState();
    _updateStream();
  }

  @override
  void didUpdateWidget(PostList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sortByLikes != oldWidget.sortByLikes) {
      _updateStream();
    }
  }

  void _updateStream() {
  _postStream = FirebaseFirestore.instance
      .collection('post')
      .orderBy(widget.sortByLikes ? 'likes' : 'date', descending: true)
      .snapshots();
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _postStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('게시물이 없습니다.'));
        }
        final posts = snapshot.data!.docs;
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
      await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.postId)
          .update({'likes': FieldValue.increment(-1)});
      if (mounted) {
        setState(() {
          likeCount -= 1;
          isLiked = false;
        });
      }
    } else {
      await likeRef.set({});
      await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.postId)
          .update({'likes': FieldValue.increment(1)});
      if (mounted) {
        setState(() {
          likeCount += 1;
          isLiked = true;
        });
      }
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('예'),
              onPressed: () {
                deletePost();
                Navigator.of(context).pop();
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
                      if (currentUser != null &&
                          currentUser.uid == widget.uid) ...[
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
    final postDoc = await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.postId)
        .get();
    if (postDoc.exists) {
      setState(() {
        _textController.text = postDoc['context'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updatePost() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _textController.text.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.postId)
        .update({
      'context': _textController.text,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final String profileImageUrl = currentUser?.photoURL ??
        'https://www.example.com/default_profile_image.png';

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
