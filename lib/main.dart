import 'package:flutter/material.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await checkAndUpdateChallenges();  // 앱 시작 시 만료된 챌린지 확인 및 업데이트
  runApp(
    ChangeNotifierProvider(
      create: (_) => NavBarModel(),
      child: MyApp(),
    ),
  );
}

Future<void> checkAndUpdateChallenges() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user == null) return;

  CollectionReference challengesRef = firestore.collection('challenge');
  CollectionReference usersRef = firestore.collection('users');

  DateTime now = DateTime.now();
  QuerySnapshot querySnapshot = await challengesRef
      .where('overDate', isLessThanOrEqualTo: now)
      .where('uid', isEqualTo: user.uid)
      .get();

  for (var doc in querySnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    String uid = data['uid'];
    int overPoint = data['overPoint'];

    DocumentReference userDoc = usersRef.doc(uid);
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userDoc);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      int newPoints = (snapshot.data() as Map<String, dynamic>)['MyPoints'] + overPoint;
      transaction.update(userDoc, {'MyPoints': newPoints});
      transaction.delete(doc.reference);
    });
  }
}

class NavBarModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
