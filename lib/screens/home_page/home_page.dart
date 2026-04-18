import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ap1_glossar/constants/colors.dart';
import 'package:ap1_glossar/data/data.dart';
import 'package:ap1_glossar/data/related.dart';
import 'package:ap1_glossar/screens/home_page/widgets/drawer.dart';
import 'package:ap1_glossar/main.dart';

// ── Aspekt-Enum ───────────────────────────────────────────────────────────────
enum Aspekt { alle, funktional, oekonomisch, oekologisch, sozial, berechnung }

extension AspektExt on Aspekt {
  String get label {
    switch (this) {
      case Aspekt.alle:
        return 'Alle';
      case Aspekt.funktional:
        return 'Funktional';
      case Aspekt.oekonomisch:
        return 'Ökonomisch';
      case Aspekt.oekologisch:
        return 'Ökologisch';
      case Aspekt.sozial:
        return 'Sozial';
      case Aspekt.berechnung:
        return 'Berechnung';
    }
  }

  Color get bgColor {
    switch (this) {
      case Aspekt.alle:
        return AppColors.allFilter;
      case Aspekt.funktional:
        return AppColors.funktional;
      case Aspekt.oekonomisch:
        return AppColors.oekonomisch;
      case Aspekt.oekologisch:
        return AppColors.oekologisch;
      case Aspekt.sozial:
        return AppColors.sozial;
      case Aspekt.berechnung:
        return AppColors.berechnung;
    }
  }

  Color get lightColor {
    switch (this) {
      case Aspekt.alle:
        return AppColors.allFilterLight;
      case Aspekt.funktional:
        return AppColors.funktionalLight;
      case Aspekt.oekonomisch:
        return AppColors.oekonomischLight;
      case Aspekt.oekologisch:
        return AppColors.oekologischLight;
      case Aspekt.sozial:
        return AppColors.sozialLight;
      case Aspekt.berechnung:
        return AppColors.berechnungLight;
    }
  }

  IconData get icon {
    switch (this) {
      case Aspekt.alle:
        return Icons.apps_rounded;
      case Aspekt.funktional:
        return Icons.settings_ethernet_rounded;
      case Aspekt.oekonomisch:
        return Icons.euro_rounded;
      case Aspekt.oekologisch:
        return Icons.eco_rounded;
      case Aspekt.sozial:
        return Icons.people_rounded;
      case Aspekt.berechnung:
        return Icons.calculate_rounded;
    }
  }
}

// ── Themencluster-Icons ───────────────────────────────────────────────────────
IconData _themaIcon(String thema) {
  switch (thema) {
    case 'Hardware':
      return Icons.memory_rounded;
    case 'Netzwerk':
      return Icons.lan_rounded;
    case 'IT-Sicherheit':
      return Icons.security_rounded;
    case 'Datenschutz':
      return Icons.shield_rounded;
    case 'Nachhaltigkeit':
      return Icons.eco_rounded;
    case 'Wirtschaft':
      return Icons.trending_up_rounded;
    case 'Projektmanagement':
      return Icons.account_tree_rounded;
    case 'Programmierung':
      return Icons.code_rounded;
    case 'Künstliche Intelligenz':
      return Icons.smart_toy_rounded;
    case 'Ergonomie & Soziales':
      return Icons.self_improvement_rounded;
    case 'Barrierefreiheit':
      return Icons.accessibility_rounded;
    case 'Recht':
      return Icons.gavel_rounded;
    case 'Berechnung':
      return Icons.calculate_rounded;
    case 'Cloud & Virtualisierung':
      return Icons.cloud_rounded;
    case 'IT-Service-Management':
      return Icons.support_agent_rounded;
    case 'Systemadministration':
      return Icons.admin_panel_settings_rounded;
    case 'Datenspeicherung':
      return Icons.storage_rounded;
    case 'Kommunikation':
      return Icons.forum_rounded;
    case 'WiSo Ausbildung & Arbeitsrecht':
      return Icons.school_rounded;
    case 'WiSo Unternehmen & Wirtschaft':
      return Icons.business_rounded;
    case 'WiSo Sicherheit & Umwelt':
      return Icons.park_rounded;
    case 'WiSo Digitale Zusammenarbeit':
      return Icons.group_work_rounded;
    default:
      return Icons.label_rounded;
  }
}

// ── Sortierte Themencluster-Liste ─────────────────────────────────────────────
const List<String> _themenReihenfolge = [
  'Hardware',
  'Netzwerk',
  'IT-Sicherheit',
  'Datenschutz',
  'Programmierung',
  'Datenbanken',
  'Cloud & Virtualisierung',
  'Systemadministration',
  'Datenspeicherung',
  'IT-Service-Management',
  'Künstliche Intelligenz',
  'Projektmanagement',
  'Wirtschaft',
  'Berechnung',
  'Nachhaltigkeit',
  'Ergonomie & Soziales',
  'Barrierefreiheit',
  'Kommunikation',
  'Recht',
  'WiSo Ausbildung & Arbeitsrecht',
  'WiSo Unternehmen & Wirtschaft',
  'WiSo Sicherheit & Umwelt',
  'WiSo Digitale Zusammenarbeit',
];

// ── HomePage ──────────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  final String? deepLinkTerm;
  const HomePage({Key? key, this.deepLinkTerm}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> _visibleKeys = [];
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Aspekt _selectedAspekt = Aspekt.alle;
  String? _selectedThema; // null = alle Themen
  String? _activeDeepLinkTerm;

  @override
  void initState() {
    super.initState();
    _applyFilter();
    if (widget.deepLinkTerm != null &&
        abbreviations.containsKey(widget.deepLinkTerm)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigateToTerm(widget.deepLinkTerm!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Alle Themencluster-Namen aus related.dart (nur die die Begriffe enthalten)
  List<String> get _availableThemen {
    final known = termGroups.keys.toSet();
    return _themenReihenfolge.where((t) => known.contains(t)).toList()
      ..addAll(known.where((t) => !_themenReihenfolge.contains(t)).toList());
  }

  // Welche Begriffe gehören zu einem Thema?
  Set<String> _keysForThema(String thema) {
    return (termGroups[thema] ?? []).toSet();
  }

  void _applyFilter(
      {String? search,
      Aspekt? aspekt,
      String? thema,
      bool clearThema = false}) {
    final s = (search ?? _searchController.text).toLowerCase().trim();
    final a = aspekt ?? _selectedAspekt;
    final t = clearThema ? null : (thema ?? _selectedThema);
    final allKeys = abbreviations.keys.toList();

    final themaKeys = t != null ? _keysForThema(t) : null;

    setState(() {
      _selectedAspekt = a;
      _selectedThema = t;

      final filtered = allKeys.where((key) {
        final matchSearch = s.isEmpty ||
            key.toLowerCase().contains(s) ||
            (abbreviations[key] ?? '').toLowerCase().contains(s);
        final matchAspekt =
            a == Aspekt.alle || (termAspect[key] ?? 'Funktional') == a.label;
        final matchThema = themaKeys == null || themaKeys.contains(key);
        return matchSearch && matchAspekt && matchThema;
      }).toList();

      // Begriffe mit Buchstaben zuerst, Zahlen/Sonderzeichen ans Ende
      filtered.sort((a, b) {
        final aLetter = RegExp(r'^[A-Za-z\u00C0-\u024F]').hasMatch(a);
        final bLetter = RegExp(r'^[A-Za-z\u00C0-\u024F]').hasMatch(b);
        if (aLetter && !bLetter) return -1;
        if (!aLetter && bLetter) return 1;
        return a.toLowerCase().compareTo(b.toLowerCase());
      });

      _visibleKeys = filtered;
    });
  }

  void navigateToTerm(String term) {
    // Set search to exact term name
    _searchController.text = term;
    _applyFilter(search: term, aspekt: Aspekt.alle, clearThema: true);
    _activeDeepLinkTerm = term;

    // Reorder: put exact match first
    setState(() {
      final idx = _visibleKeys.indexOf(term);
      if (idx > 0) {
        _visibleKeys.remove(term);
        _visibleKeys.insert(0, term);
      }
    });

    // Scroll to top where the exact match now sits
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themen = _availableThemen;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.color,
        foregroundColor: Colors.white,
        title: const Text(
          'AP1 Coach',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 2,
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: MyApp.themeNotifier,
            builder: (context, themeMode, child) {
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: Colors.white,
                ),
                tooltip: 'Dark/Light Mode',
                onPressed: () {
                  final isDark = themeMode == ThemeMode.dark;
                  final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
                  MyApp.themeNotifier.value = newMode;
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setString(
                      'theme_mode',
                      isDark ? 'light' : 'dark',
                    );
                  });
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '${_visibleKeys.length} Begriffe',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Suchfeld ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (t) => _applyFilter(search: t),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).cardColor,
                hintText: 'Begriff oder Definition suchen …',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).hintColor),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.close,
                            color: Theme.of(context).hintColor),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilter(search: '');
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.color, width: 1.5),
                ),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),

          // ── Aspekt-Filter-Chips ──────────────────────────────────────────────
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: Aspekt.values.map((a) {
                final selected = _selectedAspekt == a;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _applyFilter(aspekt: a),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            selected ? a.bgColor : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? a.bgColor
                              : Theme.of(context).dividerColor,
                          width: 1.2,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: a.bgColor.withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(a.icon,
                              size: 13,
                              color: selected ? Colors.white : a.bgColor),
                          const SizedBox(width: 5),
                          Text(
                            a.label,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : a.bgColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 6),

          // ── Themencluster-Filter-Chips ────────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // "Alle Themen"-Chip
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: GestureDetector(
                    onTap: () => _applyFilter(clearThema: true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 5),
                      decoration: BoxDecoration(
                        color: _selectedThema == null
                            ? const Color(0xFF1B3A5C)
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedThema == null
                              ? const Color(0xFF1B3A5C)
                              : Theme.of(context).dividerColor,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.grid_view_rounded,
                              size: 12,
                              color: _selectedThema == null
                                  ? Colors.white
                                  : Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color ??
                                      Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            'Alle Themen',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: _selectedThema == null
                                  ? Colors.white
                                  : Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color ??
                                      Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Themen-Chips
                ...themen.map((thema) {
                  final selected = _selectedThema == thema;
                  final count = _keysForThema(thema).length;
                  return Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: GestureDetector(
                      onTap: () => _applyFilter(
                          thema: selected ? null : thema, clearThema: selected),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF1B3A5C)
                              : const Color(0xFFF0F3F7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF1B3A5C)
                                : Colors.grey.shade300,
                            width: 1.2,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF1B3A5C)
                                        .withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _themaIcon(thema),
                              size: 12,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF1B3A5C),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              thema,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF1B3A5C),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white.withOpacity(0.25)
                                    : const Color(0xFF1B3A5C).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xFF1B3A5C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Aktiver Filter-Hinweis ────────────────────────────────────────────
          if (_selectedThema != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Row(
                children: [
                  Icon(_themaIcon(_selectedThema!),
                      size: 13, color: const Color(0xFF1B3A5C)),
                  const SizedBox(width: 5),
                  Text(
                    _selectedThema!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B3A5C),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '· ${_visibleKeys.length} Begriffe',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _applyFilter(clearThema: true),
                    child: Icon(Icons.close_rounded,
                        size: 16,
                        color: Theme.of(context).textTheme.bodySmall?.color ??
                            Colors.grey.shade400),
                  ),
                ],
              ),
            ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFE8ECF1)),

          // ── Begriffe-Liste ───────────────────────────────────────────────────
          Expanded(
            child: _visibleKeys.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                    itemCount: _visibleKeys.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, i) {
                      final key = _visibleKeys[i];
                      final aspect = termAspect[key] ?? 'Funktional';
                      return _GlossarCard(
                        term: key,
                        definition: abbreviations[key] ?? '',
                        aspekt: _aspektFromString(aspect),
                        onRelatedTap: navigateToTerm,
                        expandOnLoad: _activeDeepLinkTerm == key,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: Theme.of(context).textTheme.bodySmall?.color ??
                Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            'Kein Begriff gefunden',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Filter oder Suchbegriff anpassen',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).textTheme.bodySmall?.color ??
                  Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Aspekt _aspektFromString(String s) {
    switch (s) {
      case 'Ökonomisch':
        return Aspekt.oekonomisch;
      case 'Ökologisch':
        return Aspekt.oekologisch;
      case 'Sozial':
        return Aspekt.sozial;
      case 'Berechnung':
        return Aspekt.berechnung;
      default:
        return Aspekt.funktional;
    }
  }
}

// ── Glossar-Karte ─────────────────────────────────────────────────────────────
class _GlossarCard extends StatefulWidget {
  final String term;
  final String definition;
  final Aspekt aspekt;
  final void Function(String) onRelatedTap;
  final bool expandOnLoad;

  const _GlossarCard({
    required this.term,
    required this.definition,
    required this.aspekt,
    required this.onRelatedTap,
    this.expandOnLoad = false,
  });

  @override
  State<_GlossarCard> createState() => _GlossarCardState();
}

class _GlossarCardState extends State<_GlossarCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  List<String>? _related;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expandOnLoad;
    if (_expanded) {
      _related = getRelatedTerms(widget.term);
    }
  }

  @override
  void didUpdateWidget(covariant _GlossarCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.expandOnLoad && widget.expandOnLoad && !_expanded) {
      setState(() {
        _expanded = true;
        _related = getRelatedTerms(widget.term);
      });
    }
  }

  void _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded && _related == null) {
        _related = getRelatedTerms(widget.term);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.aspekt.bgColor;
    final lightColor = widget.aspekt.lightColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _toggleExpand,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Kopfzeile ─────────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: lightColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          widget.term[0].toUpperCase(),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.term,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.5,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color ??
                                  Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          _AspektBadge(aspekt: widget.aspekt),
                        ],
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey.shade400,
                      size: 22,
                    ),
                  ],
                ),

                // ── Kurzdefinition (eingeklappt) ───────────────────────────
                if (!_expanded) ...[
                  const SizedBox(height: 8),
                  Text(
                    _shortDef(widget.definition),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // ── Vollständige Definition + Verwandte Begriffe ───────────
                if (_expanded) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.definition,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                  ),
                  if (_related != null && _related!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.hub_outlined,
                            size: 13, color: Colors.grey.shade500),
                        const SizedBox(width: 5),
                        Text(
                          'Verwandte Begriffe',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.bodySmall?.color ??
                                    Colors.grey.shade500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _related!.map((related) {
                        final relAspekt = _aspektFromString(
                            termAspect[related] ?? 'Funktional');
                        return GestureDetector(
                          onTap: () => widget.onRelatedTap(related),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: relAspekt.bgColor.withOpacity(0.5),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: relAspekt.bgColor.withOpacity(0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_forward_rounded,
                                    size: 11, color: relAspekt.bgColor),
                                const SizedBox(width: 5),
                                Text(
                                  related,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: relAspekt.bgColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _shortDef(String def) {
    if (def.length <= 110) return def;
    return '${def.substring(0, 110)}…';
  }

  Aspekt _aspektFromString(String s) {
    switch (s) {
      case 'Ökonomisch':
        return Aspekt.oekonomisch;
      case 'Ökologisch':
        return Aspekt.oekologisch;
      case 'Sozial':
        return Aspekt.sozial;
      case 'Berechnung':
        return Aspekt.berechnung;
      default:
        return Aspekt.funktional;
    }
  }
}

// ── Aspekt-Badge ──────────────────────────────────────────────────────────────
class _AspektBadge extends StatelessWidget {
  final Aspekt aspekt;
  const _AspektBadge({required this.aspekt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: aspekt.lightColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: aspekt.bgColor.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(aspekt.icon, size: 11, color: aspekt.bgColor),
          const SizedBox(width: 3),
          Text(
            aspekt.label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: aspekt.bgColor,
            ),
          ),
        ],
      ),
    );
  }
}
