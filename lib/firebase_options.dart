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
    apiKey: 'AIzaSyBDA3ngLPteKZJahwAlLi-WX_PqQ_VnbAc',
    appId: '1:475749949787:web:2e716d056206cf76153a7e',
    messagingSenderId: '475749949787',
    projectId: 'besttask-4058d',
    authDomain: 'besttask-4058d.firebaseapp.com',
    storageBucket: 'besttask-4058d.firebasestorage.app',
    measurementId: 'G-3K9N65D990',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRv_4Jmc3euPfScuECENgeKTVCYMPjv2o',
    appId: '1:475749949787:android:269777885d26d841153a7e',
    messagingSenderId: '475749949787',
    projectId: 'besttask-4058d',
    storageBucket: 'besttask-4058d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5D0JcfqUyZRZ0lVPHatNH6ob0Da7YT8A',
    appId: '1:475749949787:ios:e720b43412bfe079153a7e',
    messagingSenderId: '475749949787',
    projectId: 'besttask-4058d',
    storageBucket: 'besttask-4058d.firebasestorage.app',
    iosBundleId: 'com.example.craftBay',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5D0JcfqUyZRZ0lVPHatNH6ob0Da7YT8A',
    appId: '1:475749949787:ios:e720b43412bfe079153a7e',
    messagingSenderId: '475749949787',
    projectId: 'besttask-4058d',
    storageBucket: 'besttask-4058d.firebasestorage.app',
    iosBundleId: 'com.example.craftBay',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBDA3ngLPteKZJahwAlLi-WX_PqQ_VnbAc',
    appId: '1:475749949787:web:c4540af0af234666153a7e',
    messagingSenderId: '475749949787',
    projectId: 'besttask-4058d',
    authDomain: 'besttask-4058d.firebaseapp.com',
    storageBucket: 'besttask-4058d.firebasestorage.app',
    measurementId: 'G-2368GJE540',
  );
}
