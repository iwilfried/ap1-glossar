// WICHTIG: Single Source of Truth fuer das LF-Logo.
// Das Widget rendert das PNG aus assets/icons/lf_logo.png.
// Diese muss identisch zu web/icons/lf_logo.png sein.
// Bei Aenderungen am Logo muessen BEIDE Dateien angepasst werden.

import 'package:flutter/material.dart';

class LFLogo extends StatelessWidget {
  final double size;
  const LFLogo({this.size = 100, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/lf_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
