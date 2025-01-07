import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDEXLMT9d30YhE-EDOhDPbPacqMNm6HXxI',
    appId: '1:149530670512:android:4fc26093fa0b44e32b1275',
    messagingSenderId: '149530670512',
    projectId: 'adimobil-7a542',
    authDomain: 'adimobil-7a542.firebaseapp.com',
    storageBucket: 'adimobil-7a542.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDEXLMT9d30YhE-EDOhDPbPacqMNm6HXxI',
    appId: '1:149530670512:android:4fc26093fa0b44e32b1275',
    messagingSenderId: '149530670512',
    projectId: 'adimobil-7a542',
    storageBucket: 'adimobil-7a542.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEXLMT9d30YhE-EDOhDPbPacqMNm6HXxI',
    appId: '1:149530670512:android:4fc26093fa0b44e32b1275',
    messagingSenderId: '149530670512',
    projectId: 'adimobil-7a542',
    storageBucket: 'adimobil-7a542.firebasestorage.app',
    iosClientId: '149530670512-YOUR-IOS-CLIENT-ID',
    iosBundleId: 'com.example.yamanapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEXLMT9d30YhE-EDOhDPbPacqMNm6HXxI',
    appId: '1:149530670512:android:4fc26093fa0b44e32b1275',
    messagingSenderId: '149530670512',
    projectId: 'adimobil-7a542',
    storageBucket: 'adimobil-7a542.firebasestorage.app',
    iosClientId: '149530670512-YOUR-MACOS-CLIENT-ID',
    iosBundleId: 'com.example.yamanapp',
  );
} 