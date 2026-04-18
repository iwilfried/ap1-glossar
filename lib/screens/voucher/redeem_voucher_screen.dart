import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ap1_glossar/services/firebase_service.dart';

class RedeemVoucherScreen extends StatefulWidget {
  const RedeemVoucherScreen({super.key});

  @override
  State<RedeemVoucherScreen> createState() => _RedeemVoucherScreenState();
}

class _RedeemVoucherScreenState extends State<RedeemVoucherScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  Timer? _closeTimer;

  @override
  void dispose() {
    _codeController.dispose();
    _closeTimer?.cancel();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _errorMessage = 'Bitte gib einen Code ein.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final result = await FirebaseService.instance.redeemVoucher(code);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _successMessage = (result['message'] as String?) ??
            'Prüfungspass aktiviert! Viel Erfolg bei deiner AP1!';
      });
      _closeTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) Navigator.of(context).pop();
      });
    } on FirebaseFunctionsException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message ?? 'Code konnte nicht eingelöst werden.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Fehler beim Einlösen. Bitte versuche es erneut.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code einlösen'),
        backgroundColor: const Color(0xFF1B3A5C),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.card_giftcard_rounded,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Code einlösen',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Hast du einen Zugangscode von deinem Bildungsträger erhalten? Gib ihn hier ein.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _codeController,
                enabled: !_isLoading && _successMessage == null,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                maxLength: 20,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9-]')),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    return TextEditingValue(
                      text: newValue.text.toUpperCase(),
                      selection: newValue.selection,
                    );
                  }),
                ],
                decoration: const InputDecoration(
                  labelText: 'Code',
                  hintText: 'z.B. BBQ-DUS-001',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      (_isLoading || _successMessage != null) ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle,
                          color: Colors.white, size: 22),
                  label: Text(
                    _isLoading ? 'Prüfe Code…' : 'Code einlösen',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 56),
                  ),
                ),
              ),
              if (_successMessage != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: Colors.green.withValues(alpha: 0.12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          _successMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Viel Erfolg bei deiner AP1!',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Card(
                  color: Colors.red.withValues(alpha: 0.12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
