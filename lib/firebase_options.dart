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
    apiKey: 'AIzaSyB88gZyOalpxsxaIPD1uOhYfNNNE7zZ-hw',
    appId: '1:1007332612331:web:cbee9e9950c6448c1086ae',
    messagingSenderId: '1007332612331',
    projectId: 'tweet-e9ac7',
    authDomain: 'tweet-e9ac7.firebaseapp.com',
    storageBucket: 'tweet-e9ac7.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANKvUQztgXRgJMe5LZ0FrUrmfJ9sHAeYw',
    appId: '1:1007332612331:android:2c14ace8cb1344661086ae',
    messagingSenderId: '1007332612331',
    projectId: 'tweet-e9ac7',
    storageBucket: 'tweet-e9ac7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSCbWSobx_ZXbBfCZlDNVC_kf5FILUy2o',
    appId: '1:1007332612331:ios:632917b4fbcc46f31086ae',
    messagingSenderId: '1007332612331',
    projectId: 'tweet-e9ac7',
    storageBucket: 'tweet-e9ac7.appspot.com',
    iosBundleId: 'com.example.tweet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBSCbWSobx_ZXbBfCZlDNVC_kf5FILUy2o',
    appId: '1:1007332612331:ios:219247654b0389a81086ae',
    messagingSenderId: '1007332612331',
    projectId: 'tweet-e9ac7',
    storageBucket: 'tweet-e9ac7.appspot.com',
    iosBundleId: 'com.example.tweet.RunnerTests',
  );
}
