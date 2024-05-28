import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  int i = 0;

  @override
  Widget build(BuildContext context) {
    var r = TextStyle(color: Colors.purpleAccent, fontSize: 34);
    return Stack(
      children: <Widget>[
        Scaffold(
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
                        i = 0;
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (index >= 1) {
                              if (snapshot.data!.docs[index]['MyPoints'] ==
                                  snapshot.data!.docs[index - 1]['MyPoints']) {
                              } else {
                                i++;
                              }
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: i == 0
                                            ? Colors.amber
                                            : i == 1
                                                ? Colors.grey
                                                : i == 2
                                                    ? Colors.brown
                                                    : Colors.white,
                                        width: 3.0,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, top: 10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        ['Name']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 6,
                                                  ),
                                                ),
                                                Text(
                                                  "Points: " +
                                                      snapshot.data!
                                                          .docs[index]
                                                          ['MyPoints']
                                                          .toString(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(child: Container()),
                                          i == 0
                                              ? Text("🥇", style: r)
                                              : i == 1
                                                  ? Text(
                                                      "🥈",
                                                      style: r,
                                                    )
                                                  : i == 2
                                                      ? Text(
                                                          "🥉",
                                                          style: r,
                                                        )
                                                      : Text(''),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.0,
                                                top: 13.0,
                                                right: 20.0),
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              child: Text(
                                                "Challenge",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
        ),
      ],
    );
  }
}
