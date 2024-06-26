// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDcX5Ruxi6PM-s8cxYFgjwjbn_SGNpjiw4',
    appId: '1:8429996416:web:091740d79068bac1f15965',
    messagingSenderId: '8429996416',
    projectId: 'bookstore-a5453',
    authDomain: 'bookstore-a5453.firebaseapp.com',
    databaseURL: 'https://bookstore-a5453-default-rtdb.firebaseio.com',
    storageBucket: 'bookstore-a5453.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBc9o56jTSBAXykJJ-Mojykv52J39PTVD8',
    appId: '1:8429996416:android:6c5b4a76225ecddbf15965',
    messagingSenderId: '8429996416',
    projectId: 'bookstore-a5453',
    storageBucket: 'bookstore-a5453.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzTYgWHG7wztZl9KZcD7ORAH9WPEN9ALI',
    appId: '1:8429996416:ios:d3c4289136530621f15965',
    messagingSenderId: '8429996416',
    projectId: 'bookstore-a5453',
    storageBucket: 'bookstore-a5453.appspot.com',
    iosBundleId: 'com.example.bookstore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAzTYgWHG7wztZl9KZcD7ORAH9WPEN9ALI',
    appId: '1:8429996416:ios:c61ced526983a4b3f15965',
    messagingSenderId: '8429996416',
    projectId: 'bookstore-a5453',
    storageBucket: 'bookstore-a5453.appspot.com',
    iosBundleId: 'com.example.bookstore.RunnerTests',
  );
}
