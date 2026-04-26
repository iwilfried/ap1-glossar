import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ap1_glossar/data/related.dart';
import 'package:ap1_glossar/services/firebase_service.dart';
import 'package:ap1_glossar/services/fcm_service.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  String _selectedTheme = 'alle';
  String _notificationTime = '09:00';
  int _termsPerDay = 2;
  bool _weekdaysOnly = true;
  bool _dailyPushEnabled = false;
  NotificationSettings? _permissionSettings;
  bool _isSaving = false;
  bool _isSendingTest = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await FirebaseService.instance.getUserPrefs();
    final settings = await FcmService.instance.getPermissionStatus();

    setState(() {
      _selectedTheme = (prefs?['selectedTheme'] as String?) ?? 'alle';
      _notificationTime = (prefs?['notificationTime'] as String?) ?? '09:00';
      _termsPerDay = (prefs?['termsPerDay'] as int?) ?? 2;
      _weekdaysOnly = (prefs?['weekdaysOnly'] as bool?) ?? true;
      _dailyPushEnabled = (prefs?['dailyPushEnabled'] as bool?) ?? false;
      _permissionSettings = settings;
    });
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    await FirebaseService.instance.updateUserPrefs({
      'selectedTheme': _selectedTheme,
      'notificationTime': _notificationTime,
      'termsPerDay': _termsPerDay,
      'weekdaysOnly': _weekdaysOnly,
      'dailyPushEnabled': _dailyPushEnabled,
    });
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Einstellungen gespeichert')),
      );
    }
  }

  Future<void> _requestPermission() async {
    final settings = await FcmService.instance.requestPermission();
    setState(() {
      _permissionSettings = settings;
    });
    if (mounted) {
      final isAuth = settings.authorizationStatus == AuthorizationStatus.authorized;
      final message = isAuth
          ? 'Benachrichtigungen aktiviert — Token wird gespeichert...'
          : 'Benachrichtigungen nicht aktiviert';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: isAuth ? 3 : 4),
        ),
      );
    }
  }

  Future<void> _sendTestPush() async {
    if (_permissionSettings?.authorizationStatus != AuthorizationStatus.authorized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte aktiviere zuerst Benachrichtigungen.')),
      );
      return;
    }

    setState(() => _isSendingTest = true);

    try {
      // Schritt 1: Sicherstellen dass Token vorhanden ist
      // (3 Versuche mit Backoff, falls Token noch nicht generiert wurde)
      final token = await FcmService.instance.getTokenAndSave(retries: 3);

      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'FCM-Token konnte nicht erzeugt werden. '
                'Bitte App neu laden (Strg+Shift+R) und erneut versuchen.',
              ),
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      // Schritt 2: Token muss in Firestore landen — kurzer Delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Schritt 3: Cloud Function aufrufen
      final callable = FirebaseFunctions
          .instanceFor(region: 'europe-west1')
          .httpsCallable('testDailyChallenge');
      final result = await callable.call();
      final term = result.data['term'] as String? ?? '?';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Test-Push gesendet (Begriff: $term)')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), duration: const Duration(seconds: 6)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSendingTest = false);
    }
  }

  /// Diagnose-Dialog: zeigt Permission-Status und Token-Status für Support
  Future<void> _showDiagnostics() async {
    final info = await FcmService.instance.getDiagnosticInfo();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Push-Diagnose'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Permission: ${info['permission']}'),
            const SizedBox(height: 8),
            Text('Token vorhanden: ${info['hasToken']}'),
            const SizedBox(height: 8),
            Text('Token: ${info['tokenPreview']}',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final token = await FcmService.instance.getTokenAndSave(retries: 3);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(token != null
                        ? 'Token aktualisiert ✓'
                        : 'Token konnte nicht geholt werden'),
                  ),
                );
              }
            },
            child: const Text('Token erneuern'),
          ),
        ],
      ),
    );
  }

  String _themeLabel(String value) {
    if (value == 'alle') return 'Alle Themen';
    return value;
  }

  String _permissionLabel() {
    if (_permissionSettings == null) return 'Nicht verfügbar';
    switch (_permissionSettings!.authorizationStatus) {
      case AuthorizationStatus.authorized:
        return 'Erlaubt';
      case AuthorizationStatus.provisional:
        return 'Vorläufig erlaubt';
      case AuthorizationStatus.denied:
        return 'Abgelehnt';
      case AuthorizationStatus.notDetermined:
        return 'Nicht bestimmt';
    }
  }

  bool get _pushAuthorized =>
      _permissionSettings?.authorizationStatus == AuthorizationStatus.authorized;

  @override
  Widget build(BuildContext context) {
    final themes = ['alle', ...termGroups.keys];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benachrichtigungen'),
        backgroundColor: const Color(0xFF1B3A5C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            tooltip: 'Push-Diagnose',
            onPressed: _showDiagnostics,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Tägliche Challenge Einstellungen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ── Frage des Tages aktivieren ─────────────────────────────────
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        '🎯 Frage des Tages',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'Tägliche Push-Erinnerung mit einem Lernbegriff zur gewählten Uhrzeit',
                      ),
                      value: _dailyPushEnabled && _pushAuthorized,
                      onChanged: _pushAuthorized
                          ? (value) => setState(() => _dailyPushEnabled = value)
                          : null,
                    ),
                    if (!_pushAuthorized)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Aktiviere zuerst die System-Benachrichtigungen weiter unten.',
                          style: TextStyle(color: Colors.orange.shade700, fontSize: 13),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _selectedTheme,
              decoration: const InputDecoration(labelText: 'Thema'),
              items: themes
                  .map((theme) => DropdownMenuItem(
                        value: theme,
                        child: Text(_themeLabel(theme)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedTheme = value);
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text('Uhrzeit: $_notificationTime'),
                ),
                TextButton(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: int.parse(_notificationTime.split(':')[0]),
                        minute: int.parse(_notificationTime.split(':')[1]),
                      ),
                    );
                    if (time != null) {
                      // Auf "HH:MM" 24h-Format normalisieren (für Cloud Function)
                      final h = time.hour.toString().padLeft(2, '0');
                      final m = time.minute.toString().padLeft(2, '0');
                      setState(() => _notificationTime = '$h:$m');
                    }
                  },
                  child: const Text('Ändern'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Begriffe pro Tag'),
                Slider(
                  value: _termsPerDay.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '$_termsPerDay',
                  onChanged: (value) => setState(() => _termsPerDay = value.toInt()),
                ),
              ],
            ),
            SwitchListTile(
              title: const Text('Nur Werktage'),
              value: _weekdaysOnly,
              onChanged: (value) => setState(() => _weekdaysOnly = value),
            ),
            const SizedBox(height: 16),
            Text('Push-Berechtigung: ${_permissionLabel()}'),
            const SizedBox(height: 10),
            if (!_pushAuthorized)
              ElevatedButton(
                onPressed: _requestPermission,
                child: const Text('Benachrichtigungen aktivieren'),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveSettings,
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Einstellungen speichern'),
            ),
            const SizedBox(height: 16),

            // ── Test-Push-Button ───────────────────────────────────────────
            if (_pushAuthorized)
              OutlinedButton.icon(
                onPressed: _isSendingTest ? null : _sendTestPush,
                icon: _isSendingTest
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.notifications_active),
                label: Text(_isSendingTest
                    ? 'Wird gesendet...'
                    : 'Test-Push jetzt senden'),
              ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showResetConfirmation(context),
                icon: const Icon(Icons.delete_forever, color: Colors.white),
                label: const Text(
                  'Fortschritt zurücksetzen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showResetConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fortschritt zurücksetzen?'),
        content: const Text(
          'Möchtest du deinen Fortschritt wirklich zurücksetzen? Streak, Challenges und Freitext-Ergebnisse werden gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Zurücksetzen'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await FirebaseService.instance.resetProgress();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fortschritt wurde zurückgesetzt.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fehler beim Zurücksetzen.')),
          );
        }
      }
    }
  }
}
