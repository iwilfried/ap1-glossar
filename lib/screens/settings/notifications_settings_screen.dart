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
  NotificationSettings? _permissionSettings;
  bool _isSaving = false;

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
      final message = settings.authorizationStatus == AuthorizationStatus.authorized
          ? 'Benachrichtigungen aktiviert' : 'Benachrichtigungen nicht aktiviert';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
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

  @override
  Widget build(BuildContext context) {
    final themes = ['alle', ...termGroups.keys];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benachrichtigungen'),
        backgroundColor: const Color(0xFF1B3A5C),
        foregroundColor: Colors.white,
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
                      setState(() => _notificationTime = time.format(context));
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
            if (_permissionSettings?.authorizationStatus != AuthorizationStatus.authorized)
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
