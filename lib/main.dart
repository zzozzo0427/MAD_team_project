import 'package:flutter/material.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Firebase 초기화 후 사용자 로그인 상태 확인
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    // 사용자가 로그인되어 있는 경우만 챌린지 체크
    if (user != null) {
      await checkAndUpdateChallenges(user);
    }
  } catch (e) {
    print("Firebase 초기화 오류: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => NavBarModel(),
      child: MyApp(),
    ),
  );
}

Future<void> checkAndUpdateChallenges(User user) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference challengesRef = firestore.collection('challenge');
  CollectionReference usersRef = firestore.collection('users');

  DateTime now = DateTime.now();
  try {
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
  } catch (e) {
    print("챌린지 업데이트 오류: $e");
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
