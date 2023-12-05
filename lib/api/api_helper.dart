import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
    apiKey: 'AIzaSyAtpQrBXFXkh3yKtScTJ-fMeQ1UKQg5jrU',
    appId: '1:881325615829:android:1f369425101cac5655505c',
    messagingSenderId: '881325615829',
    projectId: 'appp-b8b91',
    authDomain: 'appp-b8b91.firebaseapp.com',
    storageBucket: 'appp-b8b91.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtpQrBXFXkh3yKtScTJ-fMeQ1UKQg5jrU',
    appId: '1:881325615829:android:1f369425101cac5655505c',
    messagingSenderId: '881325615829',
    projectId: 'appp-b8b91',
    storageBucket: 'appp-b8b91.appspot.com',
  );
}

// Firestore сантай холбогддог класс
class ApiHelper {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static List<QueryDocumentSnapshot<Map<String, dynamic>>> categories =
      List.empty();
  static List<QueryDocumentSnapshot<Map<String, dynamic>>> folks =
      List.empty(growable: true);

  static User get user => FirebaseAuth.instance.currentUser!;
  static String get uuid => FirebaseAuth.instance.currentUser!.uid;

  // Firebase тэй холбогдох
  static Future<void> init() async {
    await Firebase.initializeApp(
        /*options: DefaultFirebaseOptions.currentPlatform,*/);
  }

  // Firestore оос санал болгосон үлгэрүүдийг авах
  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getSuggestedFolks() async {
    final response = await firestore.collection("folks").limit(5).get();

    return response.docs;
  }

  // Firestore оос сангаас категори авах
  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getCategories() async {
    final response = await firestore.collection("Folks' category").get();

    return response.docs;
  }

  // Firestore оос сангаас категори ID г ашиглана үлгэрүүдээ татаж авах
  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getFolks(
      {required String categoryId}) async {
    final response = await firestore
        .collection("folks")
        .where('category_id', isEqualTo: categoryId)
        .get();

    return response.docs;
  }

  // Firestore оос сангаас folk ID г ашиглана тухайн үлгэрийг татаж авах
  static Future<DocumentSnapshot<Map<String, dynamic>>> getFolk(
      {required String folkId}) async {
    final response = firestore.collection("folks").doc(folkId);

    return await response.get();
  }

  // Firestore оос сангаас like дарсан үлгэрүүдээ татаж авах
  static Future<List<DocumentSnapshot<Map<String, dynamic>>>>
      getLikedFolks() async {
    final response = await firestore
        .collection("liked")
        .where('user_id', isEqualTo: uuid)
        .where('status', isEqualTo: true)
        .get()
        .then((event) async {
      final list = event.docs
          .map((e) async => await ApiHelper.getFolk(folkId: e['folks_id']))
          .toList();
      return await Future.wait(list);
    });

    return response;
  }

  // Firestore оос сангаас like дарсан мэдээлэл авах
  static Future<bool> getLiked({required String folksId}) async {
    final response = await firestore
        .collection("liked")
        .where('folks_id', isEqualTo: folksId)
        .where('user_id', isEqualTo: uuid)
        .get();

    if (response.docs.isEmpty) {
      return false;
    } else {
      return response.docs.first.get('status');
    }
  }

  // Firestore оос санд like дарсан мэдээллээ явуулах
  static Future<bool> setLiked(
      {required String folksId, required bool isLiked}) async {
    final currentStatus = await firestore
        .collection('liked')
        .where('folks_id', isEqualTo: folksId)
        .where('user_id', isEqualTo: uuid)
        .get();

    if (currentStatus.docs.isEmpty) {
      await firestore.collection("liked").add({
        'user_id': uuid,
        'folks_id': folksId,
        'status': isLiked,
        'created_at': DateTime.now(),
      });
    } else {
      currentStatus.docs.first.reference.update({
        'status': isLiked,
        'updated_at': DateTime.now(),
      });
    }

    return true;
  }

  static void addUser() {
    firestore.collection('Users').doc(uuid).set({
      'Email': user.email,
      'ImageUrl': user.photoURL,
      'Name': user.displayName,
      'Phone': user.phoneNumber
    });
  }
}
