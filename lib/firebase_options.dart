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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDG1MzYXSWKha-UivNI9gcPZtEK2qPuMXs',
    appId: '1:531182173596:android:ff3799722b67cea4dc1c59',
    messagingSenderId: '531182173596',
    projectId: 'ditonton-dcfbb',
    storageBucket: 'ditonton-dcfbb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAGNnPFj4nb3C7VJwf1JfueGzdgGMgCN7w',
    appId: '1:531182173596:ios:9e7b96c2849dd0c1dc1c59',
    messagingSenderId: '531182173596',
    projectId: 'ditonton-dcfbb',
    storageBucket: 'ditonton-dcfbb.firebasestorage.app',
    iosBundleId: 'com.example.ditonton',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD3Fslufxn5bCainlNUHYgMMhG-nU_JBcg',
    appId: '1:531182173596:web:80d73c707c491987dc1c59',
    messagingSenderId: '531182173596',
    projectId: 'ditonton-dcfbb',
    authDomain: 'ditonton-dcfbb.firebaseapp.com',
    storageBucket: 'ditonton-dcfbb.firebasestorage.app',
    measurementId: 'G-ZJLC7CVH0F',
  );

}