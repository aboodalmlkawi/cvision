import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
            'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
    apiKey: 'AIzaSyDd5R7Mvwz3XnYOqBLQynx0xAhXDyxr_ms',
    appId: '1:858577683771:android:c9655a758fe4564e62a31e',
    messagingSenderId: '858577683771',
    projectId: 'cvision-d2b19',
    storageBucket: 'cvision-d2b19.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGfLBw6aTioKQDve6YuNYGt_3pXt0h1Ao',
    appId: '1:858577683771:ios:45b30e3deb886ecf62a31e',
    messagingSenderId: '858577683771',
    projectId: 'cvision-d2b19',
    storageBucket: 'cvision-d2b19.firebasestorage.app',
    iosBundleId: 'com.almlkawi.cvision.cvision',
  );

}