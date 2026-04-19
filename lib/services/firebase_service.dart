import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

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
        'lastQuizDate': Timestamp.fromDate(DateTime.utc(1970, 1, 1)),
        'totalChallenges': 0,
        'createdAt': Timestamp.now(),
      });
    }
  }

  Future<bool> canStartQuiz() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    if (await isUserPro()) {
      return true;
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data();
    final lastQuizTimestamp = data?['lastQuizDate'] as Timestamp?;
    if (lastQuizTimestamp == null) return true;

    final lastQuizDate = lastQuizTimestamp.toDate();
    return !_isSameDay(lastQuizDate, DateTime.now());
  }

  Future<void> markQuizStarted() async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (await isUserPro()) {
      return;
    }

    await _firestore.collection('users').doc(user.uid).set({
      'lastQuizDate': Timestamp.fromDate(DateTime.now()),
    }, SetOptions(merge: true));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<Map<String, dynamic>?> getUserPrefs() async {
    final uid = await getUserId();
    final snapshot = await _firestore.collection('users').doc(uid).get();
    return snapshot.data();
  }

  Future<void> updateUserPrefs(Map<String, dynamic> data) async {
    final uid = await getUserId();
    await _firestore
        .collection('users')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  Future<void> saveFcmToken(String token) async {
    final uid = await getUserId();
    final userRef = _firestore.collection('users').doc(uid);
    await userRef.set({
      'fcmToken': token,
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  Future<void> recordChallengeCompletion(
      List<String> terms, bool correct) async {
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

      transaction.set(
          userRef,
          {
            'streak': newStreak,
            'lastChallengeDate': Timestamp.fromDate(today),
            'totalChallenges': totalChallenges + 1,
          },
          SetOptions(merge: true));
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
    final yesterday = DateTime(today.year, today.month, today.day)
        .subtract(const Duration(days: 1));
    final last = DateTime(lastDate.year, lastDate.month, lastDate.day);
    return last == yesterday;
  }

  Future<bool> isUserPro() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return false;

    final data = doc.data();
    final isPro = data?['isPro'] == true;
    if (!isPro) return false;

    final examDate = data?['examDate'] as Timestamp?;
    if (examDate != null && examDate.toDate().isBefore(DateTime.now())) {
      await _firestore.collection('users').doc(user.uid).update({
        'isPro': false,
        'proExpiredAt': FieldValue.serverTimestamp(),
      });
      return false;
    }

    return true;
  }

  Stream<bool> proStatusStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(false);

    return _firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      if (!doc.exists) return false;
      return doc.data()?['isPro'] == true;
    });
  }

  Future<Map<String, dynamic>> evaluateFreetextAnswer({
    required String term,
    required String definition,
    required String question,
    required String userAnswer,
    String? aspect,
    String? theme,
  }) async {
    final callable = FirebaseFunctions.instanceFor(region: 'europe-west1')
        .httpsCallable('evaluateAnswer');
    final result = await callable.call({
      'term': term,
      'definition': definition,
      'question': question,
      'userAnswer': userAnswer,
      'aspect': aspect ?? '',
      'theme': theme ?? '',
    });
    return Map<String, dynamic>.from(result.data);
  }

  Future<Map<String, dynamic>> generateFreetextQuestion({
    required String term,
    required String definition,
    List<String> relatedTerms = const [],
    String? aspect,
    String? theme,
  }) async {
    final callable = FirebaseFunctions.instanceFor(region: 'europe-west1')
        .httpsCallable('generateQuestion');
    final result = await callable.call({
      'term': term,
      'definition': definition,
      'relatedTerms': relatedTerms,
      'aspect': aspect ?? '',
      'theme': theme ?? '',
    });
    return Map<String, dynamic>.from(result.data);
  }

  Future<Map<String, dynamic>> generateMCQuestion({
    required String term,
    required String definition,
    List<String> relatedTerms = const [],
    String? aspect,
    String? theme,
  }) async {
    final callable = FirebaseFunctions.instanceFor(region: 'europe-west1')
        .httpsCallable('generateMCQuestion');
    final result = await callable.call({
      'term': term,
      'definition': definition,
      'relatedTerms': relatedTerms,
      'aspect': aspect ?? '',
      'theme': theme ?? '',
    });
    return Map<String, dynamic>.from(result.data);
  }

  Future<void> updateMCScore(bool correct) async {
    try {
      final callable = FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('updateMCScore');
      await callable.call({'correct': correct});
    } catch (_) {
      // Stille Fehlerbehandlung — Score-Update ist nicht kritisch
    }
  }

  Future<void> setLeaderboardDisplayName(String displayName) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({'leaderboardDisplayName': displayName});
  }

  Future<Map<String, dynamic>> redeemVoucher(String code) async {
    final callable = FirebaseFunctions.instanceFor(region: 'europe-west1')
        .httpsCallable('redeemVoucher');
    final result = await callable.call({'code': code.trim().toUpperCase()});
    return Map<String, dynamic>.from(result.data);
  }

  Future<void> resetProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    
    // Delete all documents in freetextChallenges subcollection
    final freetextDocs = await userRef.collection('freetextChallenges').get();
    for (final doc in freetextDocs.docs) {
      await doc.reference.delete();
    }
    
    // Delete all documents in progress subcollection
    final progressDocs = await userRef.collection('progress').get();
    for (final doc in progressDocs.docs) {
      await doc.reference.delete();
    }
    
    // Reset user document fields
    await userRef.update({
      'streak': 0,
      'totalChallenges': 0,
      'freetextCount': 0,
      'totalFreetextScore': 0,
      'lastChallengeDate': FieldValue.delete(),
      'lastFreetextDate': FieldValue.delete(),
    });
  }
}
