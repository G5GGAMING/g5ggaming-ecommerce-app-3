// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDNEg9X--sb-fXxbj8heAgjRxLMpr5HvPY',
    appId: '1:733142246181:web:bf6b6e4ef01f9cb00e70cc',
    messagingSenderId: '733142246181',
    projectId: 'my-flutter-5614d',
    authDomain: 'my-flutter-5614d.firebaseapp.com',
    storageBucket: 'my-flutter-5614d.firebasestorage.app',
    measurementId: 'G-YXLCFBSEL2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNEg9X--sb-fXxbj8heAgjRxLMpr5HvPY',
    appId:
        '1:733142246181:android:your_android_app_id', // Note: User needs to get this from Firebase Console
    messagingSenderId: '733142246181',
    projectId: 'my-flutter-5614d',
    storageBucket: 'my-flutter-5614d.firebasestorage.app',
  );
}
