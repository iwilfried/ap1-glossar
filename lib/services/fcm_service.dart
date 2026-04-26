import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ap1_glossar/services/firebase_service.dart';
import 'package:ap1_glossar/screens/daily_challenge/daily_challenge_screen.dart';

const String kWebPushVapidKey =
    'BI1BFvkN6Bm6h4oci6_P1j7Sug04ONygPFFTHXgtv34byQlE3or36rC6Dg3x4veMyvmeiBQBhDt3ZVQL70A36Vo';

class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  GlobalKey<NavigatorState>? _navigatorKey;
  GlobalKey<ScaffoldMessengerState>? _scaffoldMessengerKey;

  Future<void> init(
    GlobalKey<NavigatorState> navigatorKey,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  ) async {
    _navigatorKey = navigatorKey;
    _scaffoldMessengerKey = scaffoldMessengerKey;

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageClick);
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageClick(initialMessage);
    }

    // Token-Refresh-Listener: holt automatisch neuen Token wenn der alte expired
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (newToken.isNotEmpty) {
        await FirebaseService.instance.saveFcmToken(newToken);
        debugPrint('FCM-Token (refresh) gespeichert: ${newToken.substring(0, 20)}...');
      }
    });

    // Token holen — aber nur wenn Permission vorhanden, sonst skip
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await getTokenAndSave();
    }
  }

  Future<NotificationSettings> requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Kleiner Delay, damit FCM die Permission verarbeiten kann
      await Future.delayed(const Duration(milliseconds: 500));
      await getTokenAndSave(retries: 3);
    }
    return settings;
  }

  Future<NotificationSettings> getPermissionStatus() async {
    return FirebaseMessaging.instance.getNotificationSettings();
  }

  /// Versucht den FCM-Token zu holen und in Firestore zu speichern.
  /// Bei Fehlern: bis zu [retries] Wiederholungen mit Delay.
  /// Returns: Token-String wenn erfolgreich, null sonst.
  Future<String?> getTokenAndSave({int retries = 1}) async {
    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        final token = await FirebaseMessaging.instance.getToken(
          vapidKey: kWebPushVapidKey,
        );
        if (token != null && token.isNotEmpty) {
          await FirebaseService.instance.saveFcmToken(token);
          debugPrint('FCM-Token gespeichert (Versuch ${attempt + 1}): ${token.substring(0, 20)}...');
          return token;
        }
        debugPrint('FCM-Token leer (Versuch ${attempt + 1}/$retries)');
      } catch (e) {
        debugPrint('FCM-Token Fehler (Versuch ${attempt + 1}/$retries): $e');
      }
      // Delay vor Retry — exponentiell backoff
      if (attempt < retries - 1) {
        await Future.delayed(Duration(milliseconds: 800 * (attempt + 1)));
      }
    }
    return null;
  }

  /// Diagnose-Helper für Settings-Screen / Debug.
  /// Returns: { 'permission': '...', 'hasToken': true/false, 'tokenPreview': '...' }
  Future<Map<String, dynamic>> getDiagnosticInfo() async {
    final settings = await getPermissionStatus();
    String? token;
    try {
      token = await FirebaseMessaging.instance.getToken(
        vapidKey: kWebPushVapidKey,
      );
    } catch (_) {
      token = null;
    }
    return {
      'permission': settings.authorizationStatus.toString(),
      'hasToken': token != null && token.isNotEmpty,
      'tokenPreview': token != null && token.length > 20
          ? '${token.substring(0, 20)}...'
          : 'kein Token',
    };
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title ?? 'AP1 Coach';
    final body = message.notification?.body ?? 'Neue Challenge wartet auf dich.';
    _scaffoldMessengerKey?.currentState?.showSnackBar(
      SnackBar(
        content: Text('$title\n$body'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Ansehen',
          onPressed: () => _handleMessageClick(message),
        ),
      ),
    );
  }

  void _handleMessageClick(RemoteMessage message) {
    final navigator = _navigatorKey?.currentState;
    if (navigator == null) return;
    navigator.push(
      MaterialPageRoute(builder: (_) => const DailyChallengeScreen()),
    );
  }
}
