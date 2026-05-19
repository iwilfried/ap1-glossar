import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

const Map<String, String> _examDateLabels = {
  'F2026': 'Frühjahr 2026',
  'H2026': 'Herbst 2026',
  'F2027': 'Frühjahr 2027',
  'H2027': 'Herbst 2027',
};

/// Öffnet das Code-Einlöse-Dialog.
/// Gibt `true` zurück, wenn erfolgreich eingelöst wurde.
Future<bool?> showRedeemCodeDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const RedeemCodeDialog(),
  );
}

class RedeemCodeDialog extends StatefulWidget {
  const RedeemCodeDialog({super.key});

  @override
  State<RedeemCodeDialog> createState() => _RedeemCodeDialogState();
}

class _RedeemCodeDialogState extends State<RedeemCodeDialog> {
  final _codeController = TextEditingController();
  String? _examDateCode;
  bool _isRedeeming = false;
  String? _errorMessage;
  bool _needsExamDate = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _redeem() async {
    final code = _codeController.text.trim().toUpperCase();
    if (!RegExp(r'^[A-Z2-9]{6}$').hasMatch(code)) {
      setState(() {
        _errorMessage =
            'Code muss aus 6 Buchstaben und Zahlen bestehen (ohne O/0/I/1/L).';
      });
      return;
    }

    if (_needsExamDate && _examDateCode == null) {
      setState(() {
        _errorMessage = 'Bitte wähle deinen Prüfungstermin.';
      });
      return;
    }

    setState(() {
      _isRedeeming = true;
      _errorMessage = null;
    });

    try {
      final functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
      final callable = functions.httpsCallable('redeemProCode');

      final params = <String, dynamic>{'code': code};
      if (_examDateCode != null) {
        params['examDateCode'] = _examDateCode;
      }

      final result = await callable.call(params);
      final message = (result.data is Map && (result.data as Map)['message'] != null)
          ? (result.data as Map)['message'].toString()
          : 'Prüfungspass aktiviert!';

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } on FirebaseFunctionsException catch (e) {
      // examDate-Fallback: Cloud Function sagt, dass ein Termin gewählt werden muss
      final needsExamDate = e.code == 'invalid-argument' &&
          (e.message?.contains('Prüfungstermin') ?? false);

      setState(() {
        _isRedeeming = false;
        _needsExamDate = needsExamDate;
        _errorMessage = e.message ?? 'Fehler beim Einlösen';
      });
    } catch (e) {
      setState(() {
        _isRedeeming = false;
        _errorMessage = 'Unerwarteter Fehler: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Prüfungspass-Code einlösen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Du hast deinen Prüfungspass bereits gekauft? Gib hier den '
              '6-stelligen Aktivierungs-Code aus deiner Bestellbestätigung '
              'ein, um deinen Pro-Zugang auf diesem Gerät zu aktivieren.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
              autofocus: true,
              enabled: !_isRedeeming,
              decoration: const InputDecoration(
                labelText: 'Code',
                hintText: 'z. B. PS4Z6C',
                border: OutlineInputBorder(),
                counterText: '',
              ),
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (value) {
                final upper = value.toUpperCase();
                if (upper != value) {
                  _codeController.value = TextEditingValue(
                    text: upper,
                    selection: TextSelection.collapsed(offset: upper.length),
                  );
                }
              },
            ),
            if (_needsExamDate) ...[
              const SizedBox(height: 20),
              const Text(
                'Prüfungstermin wählen:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._examDateLabels.entries.map((entry) {
                return RadioListTile<String>(
                  title: Text(entry.value),
                  value: entry.key,
                  groupValue: _examDateCode,
                  onChanged: _isRedeeming
                      ? null
                      : (value) => setState(() => _examDateCode = value),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isRedeeming ? null : () => Navigator.of(context).pop(false),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _isRedeeming ? null : _redeem,
          child: _isRedeeming
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Einlösen'),
        ),
      ],
    );
  }
}
