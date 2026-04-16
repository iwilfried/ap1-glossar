import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUserId() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Firebase user is not signed in.');
    }
    return user.uid;
  }

  Future<void> initUserProfile() async {
    final uid = await getUserId();
    final userRef = _firestore.collection('users').doc(uid);
    final snapshot = await userRef.get();
    if (!snapshot.exists) {
      await userRef.set({
        'selectedTheme': 'alle',
        'notificationTime': '09:00',
        'termsPerDay': 2,
        'weekdaysOnly': true,
        'fcmToken': '',
        'streak': 0,
        'lastChallengeDate': Timestamp.fromDate(DateTime.utc(1970, 1, 1)),
        'totalChallenges': 0,
        'createdAt': Timestamp.now(),
      });
    }
  }

  Future<Map<String, dynamic>?> getUserPrefs() async {
    final uid = await getUserId();
    final snapshot = await _firestore.collection('users').doc(uid).get();
    return snapshot.data();
  }

  Future<void> updateUserPrefs(Map<String, dynamic> data) async {
    final uid = await getUserId();
    await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  Future<void> saveFcmToken(String token) async {
    final uid = await getUserId();
    final userRef = _firestore.collection('users').doc(uid);
    await userRef.set({
      'fcmToken': token,
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  Future<void> recordChallengeCompletion(List<String> terms, bool correct) async {
    final uid = await getUserId();
    final userRef = _firestore.collection('users').doc(uid);
    final today = DateTime.now();
    final dateKey = _formatDate(today);
    final progressRef = userRef.collection('progress').doc(dateKey);

    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      final progressSnapshot = await transaction.get(progressRef);
      if (progressSnapshot.exists) {
        return;
      }

      final data = userSnapshot.data() ?? <String, dynamic>{};
      final prevStreak = (data['streak'] as int?) ?? 0;
      final lastTimestamp = data['lastChallengeDate'] as Timestamp?;
      final lastDate = lastTimestamp?.toDate();
      final isYesterday = lastDate != null && _isYesterday(lastDate, today);
      final newStreak = correct ? (isYesterday ? prevStreak + 1 : 1) : 0;
      final totalChallenges = (data['totalChallenges'] as int?) ?? 0;

      transaction.set(progressRef, {
        'date': dateKey,
        'terms': terms,
        'correct': correct,
        'answeredAt': Timestamp.now(),
      });

      transaction.set(userRef, {
        'streak': newStreak,
        'lastChallengeDate': Timestamp.fromDate(today),
        'totalChallenges': totalChallenges + 1,
      }, SetOptions(merge: true));
    });
  }

  Stream<Map<String, dynamic>> userStream() async* {
    final uid = await getUserId();
    yield* _firestore.collection('users').doc(uid).snapshots().map(
          (snapshot) => snapshot.data() ?? <String, dynamic>{},
        );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  bool _isYesterday(DateTime lastDate, DateTime today) {
    final yesterday = DateTime(today.year, today.month, today.day).subtract(const Duration(days: 1));
    final last = DateTime(lastDate.year, lastDate.month, lastDate.day);
    return last == yesterday;
  }
}
