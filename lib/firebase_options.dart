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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCTBuu01IR7xjzhWV9HjS8fBqUe3eqlETg',
    appId: '1:693550060570:web:6ace5bc239464710546da3',
    messagingSenderId: '693550060570',
    projectId: 'tase-b6713',
    authDomain: 'tase-b6713.firebaseapp.com',
    storageBucket: 'tase-b6713.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqdKuozY_fDWuUfd-uy2AymW0TCmijGZ4',
    appId: '1:693550060570:android:fbef159a1719eb22546da3',
    messagingSenderId: '693550060570',
    projectId: 'tase-b6713',
    storageBucket: 'tase-b6713.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJ1StMjhcni625VOpuSUo9wZfSjH6ZdgU',
    appId: '1:693550060570:ios:44bf2fc9262f1381546da3',
    messagingSenderId: '693550060570',
    projectId: 'tase-b6713',
    storageBucket: 'tase-b6713.appspot.com',
    iosBundleId: 'com.example.tase',
  );
}
