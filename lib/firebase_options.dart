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
    apiKey: 'AIzaSyCM9QKHIBScQs8zAKPcw6DeJM93KW8KOL0',
    appId: '1:22366208763:web:3d2cc932ac4911a80b265e',
    messagingSenderId: '22366208763',
    projectId: 'mechat-1f5d2',
    authDomain: 'mechat-1f5d2.firebaseapp.com',
    storageBucket: 'mechat-1f5d2.appspot.com',
    measurementId: 'G-JK74QZ285L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSOxtTUc4F8u-HHVEVKs058edQeRlUJgU',
    appId: '1:22366208763:android:3702d616a0ce2eae0b265e',
    messagingSenderId: '22366208763',
    projectId: 'mechat-1f5d2',
    storageBucket: 'mechat-1f5d2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaNQVQlLZPYe_B5pMJrhvoRC2qCCpLil8',
    appId: '1:22366208763:ios:3ef2abb46ddd1e450b265e',
    messagingSenderId: '22366208763',
    projectId: 'mechat-1f5d2',
    storageBucket: 'mechat-1f5d2.appspot.com',
    iosBundleId: 'com.example.vidshare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCaNQVQlLZPYe_B5pMJrhvoRC2qCCpLil8',
    appId: '1:22366208763:ios:dc8f0f7f2dab6ba10b265e',
    messagingSenderId: '22366208763',
    projectId: 'mechat-1f5d2',
    storageBucket: 'mechat-1f5d2.appspot.com',
    iosBundleId: 'com.example.vidshare.RunnerTests',
  );
}
