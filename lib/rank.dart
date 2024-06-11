import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smoquit'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15.0, top: 10.0),
              child: RichText(
                text: TextSpan(
                  text: "Leader",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: " Board",
                      style: TextStyle(
                          color: Colors.pink,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Global Rank Board: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .orderBy('MyPoints', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> docs = snapshot.data!.docs;
                    return Column(
                      children: <Widget>[
                        if (docs.length > 0) podiumWidget(docs),
                        Expanded(
                          child: ListView.builder(
                            itemCount: docs.length - 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                child: listTile(docs[index + 3], index + 4),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget podiumWidget(List<DocumentSnapshot> docs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        podiumTile(docs[1], 2, Color(0xFF7FC3A9), 150.0), // 2등
        podiumTile(docs[0], 1, Colors.green, 200.0), // 1등
        podiumTile(docs[2], 3, Color(0xFF7FC3A9), 100.0), // 3등
      ],
    );
  }

  Widget podiumTile(
      DocumentSnapshot doc, int rank, Color color, double height) {
    return Container(
      width: 100,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            rank.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              doc['Name'],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            child: Text(
              "points: " + doc['MyPoints'].toString(),
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget listTile(DocumentSnapshot doc, int rank) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        leading: Text('$rank', style: TextStyle(color: Colors.white)),
        title: Text(doc['Name'], style: TextStyle(color: Colors.white)),
        trailing: Text('points: ' + doc['MyPoints'].toString(),
            style: TextStyle(color: Colors.white)),
        onTap: () {},
      ),
    );
  }
}
