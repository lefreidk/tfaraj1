import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class FirebaseService {
  static bool initialized = false;

  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      initialized = true;
    } catch (_) {
      initialized = false;
    }
  }

  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get db => FirebaseFirestore.instance;

  static Future<UserCredential> signInEmail(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  }

  static Future<UserCredential> registerEmail(String email, String password) {
    return auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
  }

  static Future<void> signOut() => auth.signOut();

  static Future<int> getCoins(User user) async {
    final snap = await db.collection('users').doc(user.email).get();
    return (snap.data()?['coins'] as num?)?.toInt() ?? 0;
  }

  static Future<void> setCoins(User user, int coins) async {
    await db.collection('users').doc(user.email).set({'coins': coins}, SetOptions(merge: true));
  }

  static Future<void> incrementView(String id) async {
    await db.collection('views').doc('movies').set({
      id: FieldValue.increment(1),
    }, SetOptions(merge: true));
    await db.collection('views').doc('total').set({
      'count': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  static Future<List<AppNotification>> notifications() async {
    final snap = await db.collection('notifications').orderBy('date', descending: true).limit(50).get();
    return snap.docs.map((d) => AppNotification.fromMap(d.data())).toList();
  }
}

class AppNotification {
  final String title;
  final String body;
  final DateTime? date;

  const AppNotification({required this.title, required this.body, this.date});

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    final raw = map['date'];
    DateTime? date;
    if (raw is Timestamp) date = raw.toDate();
    if (raw is String) date = DateTime.tryParse(raw);
    return AppNotification(
      title: '${map['title'] ?? ''}',
      body: '${map['body'] ?? ''}',
      date: date,
    );
  }
}
