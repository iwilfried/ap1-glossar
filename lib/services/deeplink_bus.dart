import 'dart:async';

/// Überträgt Deeplink-Terme, die zur LAUFZEIT (App schon offen) via
/// Service-Worker-postMessage ankommen, an die HomePage. Der Kaltstart-Pfad
/// (term aus der URL in main()) bleibt davon unberührt.
final StreamController<String> deepLinkTermBus =
    StreamController<String>.broadcast();
