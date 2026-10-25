
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase options for web have not been configured.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return ios;

      case TargetPlatform.android:
        throw UnsupportedError(
          'Firebase options for Android have not been configured.',
        );

      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Firebase options have not been configured for this platform.',
        );
    }
  }

  static String _required(String key) {
    final value = dotenv.env[key];

    if (value == null || value.trim().isEmpty) {
      throw StateError(
        'Missing $key in your .env file.',
      );
    }

    return value.trim();
  }

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: _required('FIREBASE_API_KEY'),
        appId: _required('FIREBASE_APP_ID'),
        messagingSenderId:
            _required('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _required('FIREBASE_PROJECT_ID'),
        storageBucket: _required('FIREBASE_STORAGE_BUCKET'),
        iosBundleId: _required('FIREBASE_IOS_BUNDLE_ID'),
      );
}
