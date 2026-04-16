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

    await getTokenAndSave();
  }

  Future<NotificationSettings> requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await getTokenAndSave();
    }
    return settings;
  }

  Future<NotificationSettings> getPermissionStatus() async {
    return FirebaseMessaging.instance.getNotificationSettings();
  }

  Future<void> getTokenAndSave() async {
    final token = await FirebaseMessaging.instance.getToken(
      vapidKey: kWebPushVapidKey,
    );
    if (token != null && token.isNotEmpty) {
      await FirebaseService.instance.saveFcmToken(token);
    }
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
