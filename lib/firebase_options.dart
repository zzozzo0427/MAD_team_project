// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB0r7M-wA-uiZDc1PRsgwMsRAibkMAutw0',
    appId: '1:1052926683011:web:705de55f8013032827f8b6',
    messagingSenderId: '1052926683011',
    projectId: 'mad-team-project',
    authDomain: 'mad-team-project.firebaseapp.com',
    storageBucket: 'mad-team-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAe2zqCLPU8jGfl_usq4O6VVBW6U_mimIk',
    appId: '1:1052926683011:android:a8387b77e7ef4d6527f8b6',
    messagingSenderId: '1052926683011',
    projectId: 'mad-team-project',
    storageBucket: 'mad-team-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDhTjozQa6Wn1NzlWErEUCryiNq3Ws1etQ',
    appId: '1:1052926683011:ios:e3c62242d824d14c27f8b6',
    messagingSenderId: '1052926683011',
    projectId: 'mad-team-project',
    storageBucket: 'mad-team-project.appspot.com',
    iosClientId: '1052926683011-bjod2mqmebgi0d3ps38hll1636obmca8.apps.googleusercontent.com',
    iosBundleId: 'com.example.madRealProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDhTjozQa6Wn1NzlWErEUCryiNq3Ws1etQ',
    appId: '1:1052926683011:ios:e3c62242d824d14c27f8b6',
    messagingSenderId: '1052926683011',
    projectId: 'mad-team-project',
    storageBucket: 'mad-team-project.appspot.com',
    iosClientId: '1052926683011-bjod2mqmebgi0d3ps38hll1636obmca8.apps.googleusercontent.com',
    iosBundleId: 'com.example.madRealProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB0r7M-wA-uiZDc1PRsgwMsRAibkMAutw0',
    appId: '1:1052926683011:web:01c7c0d833786b6727f8b6',
    messagingSenderId: '1052926683011',
    projectId: 'mad-team-project',
    authDomain: 'mad-team-project.firebaseapp.com',
    storageBucket: 'mad-team-project.appspot.com',
  );
}
