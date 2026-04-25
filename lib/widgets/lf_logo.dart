// WICHTIG: Single Source of Truth fuer das LF-Logo.
// Bei Aenderungen MUSS auch web/icons/lf_logo.svg angepasst werden.
// Verhaeltnisse stammen aus der 200x200 SVG-ViewBox und werden ueber
// `factor = size / 200` proportional skaliert.

import 'package:flutter/material.dart';

const Color _kLogoNavy = Color(0xFF162447);
const Color _kLogoAccent = Color(0xFFE8813A);

class LFLogo extends StatelessWidget {
  final double size;
  const LFLogo({this.size = 100, super.key});

  @override
  Widget build(BuildContext context) {
    final factor = size / 200.0;
    final borderRadius = 44.0 * factor;
    final fontSize = 110.0 * factor;
    final accentWidth = 40.0 * factor;
    final accentHeight = 6.0 * factor;
    final accentRadius = 3.0 * factor;
    final gap = 4.0 * factor;

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _kLogoNavy,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LF',
              style: TextStyle(
                fontFamily: 'Helvetica',
                fontFamilyFallback: const ['Arial', 'sans-serif'],
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),
            SizedBox(height: gap),
            Container(
              width: accentWidth,
              height: accentHeight,
              decoration: BoxDecoration(
                color: _kLogoAccent,
                borderRadius: BorderRadius.circular(accentRadius),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
