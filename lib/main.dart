import 'package:flutter/material.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      await checkAndUpdateChallenges(user);
    }
  } catch (e) {
    print("Firebase 초기화 오류: $e");
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  try {
    String? token = await messaging.getToken();
    print("FCM Token: $token");
  } catch (e) {
    print("FCM 초기화 오류: $e");
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("FCM 메시지 수신: ${message.notification?.title}");
  });

  try {
    await NaverMapSdk.instance.initialize(clientId: 'hztmpwfdp5');
  } catch (e) {
    print("Naver Map 초기화 오류: $e");
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
    print("쿼리 실행 전 현재 시간: $now");
    QuerySnapshot querySnapshot = await challengesRef
        .where('overDate', isLessThanOrEqualTo: now)
        .where('uid', isEqualTo: user.uid)
        .get();

    print("쿼리 실행 후 문서 개수: ${querySnapshot.docs.length}");
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