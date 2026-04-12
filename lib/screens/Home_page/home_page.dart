import 'package:flutter/material.dart';
import 'package:nasa/constants/colors.dart';
import 'package:nasa/data/data.dart';
import 'package:nasa/screens/Home_page/widgets/drawer.dart';

// ── Filterwerte ───────────────────────────────────────────────────────────────
enum Aspekt { alle, funktional, oekonomisch, oekologisch, sozial }

extension AspektExt on Aspekt {
  String get label {
    switch (this) {
      case Aspekt.alle:        return 'Alle';
      case Aspekt.funktional:  return 'Funktional';
      case Aspekt.oekonomisch: return 'Ökonomisch';
      case Aspekt.oekologisch: return 'Ökologisch';
      case Aspekt.sozial:      return 'Sozial';
    }
  }

  String get dataKey {
    switch (this) {
      case Aspekt.alle:        return '';
      case Aspekt.funktional:  return 'Funktional';
      case Aspekt.oekonomisch: return 'Ökonomisch';
      case Aspekt.oekologisch: return 'Ökologisch';
      case Aspekt.sozial:      return 'Sozial';
    }
  }

  Color get bgColor {
    switch (this) {
      case Aspekt.alle:        return AppColors.allFilter;
      case Aspekt.funktional:  return AppColors.funktional;
      case Aspekt.oekonomisch: return AppColors.oekonomisch;
      case Aspekt.oekologisch: return AppColors.oekologisch;
      case Aspekt.sozial:      return AppColors.sozial;
    }
  }

  Color get lightColor {
    switch (this) {
      case Aspekt.alle:        return AppColors.allFilterLight;
      case Aspekt.funktional:  return AppColors.funktionalLight;
      case Aspekt.oekonomisch: return AppColors.oekonomischLight;
      case Aspekt.oekologisch: return AppColors.oekologischLight;
      case Aspekt.sozial:      return AppColors.sozialLight;
    }
  }

  IconData get icon {
    switch (this) {
      case Aspekt.alle:        return Icons.apps_rounded;
      case Aspekt.funktional:  return Icons.settings_ethernet_rounded;
      case Aspekt.oekonomisch: return Icons.euro_rounded;
      case Aspekt.oekologisch: return Icons.eco_rounded;
      case Aspekt.sozial:      return Icons.people_rounded;
    }
  }
}

// ── HomePage ──────────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // Alle Schlüssel der gewählten Ansicht
  List<String> _visibleKeys = [];
  final _searchController = TextEditingController();
  Aspekt _activeAspekt = Aspekt.alle;

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtert nach Aspekt + Suchtext
  void _applyFilter({String search = ''}) {
    final allKeys = abbreviations.keys.toList();
    final s = search.toLowerCase().trim();

    setState(() {
      _visibleKeys = allKeys.where((key) {
        // Aspekt-Filter
        final matchesAspekt = _activeAspekt == Aspekt.alle ||
            (termAspect[key] ?? '') == _activeAspekt.dataKey;

        // Suchtext-Filter (Begriff ODER Definition)
        final matchesSearch = s.isEmpty ||
            key.toLowerCase().contains(s) ||
            (abbreviations[key] ?? '').toLowerCase().contains(s);

        return matchesAspekt && matchesSearch;
      }).toList();
    });
  }

  // Anzahl Begriffe je Aspekt
  int _countFor(Aspekt a) {
    if (a == Aspekt.alle) return abbreviations.length;
    return termAspect.values.where((v) => v == a.dataKey).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.color,
        foregroundColor: Colors.white,
        title: const Text(
          'IHK AP1 – Glossar',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '${_visibleKeys.length} Begriffe',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Suchfeld ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: TextField(
              controller: _searchController,
              onChanged: (t) => _applyFilter(search: t),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Begriff oder Definition suchen …',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilter();
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _activeAspekt.bgColor,
                    width: 1.5,
                  ),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16),
              ),
            ),
          ),

          // ── Filter-Chips ─────────────────────────────────────────────────
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: Aspekt.values.map((a) {
                final isSelected = _activeAspekt == a;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          a.icon,
                          size: 15,
                          color: isSelected ? Colors.white : a.bgColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${a.label} (${_countFor(a)})',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : a.bgColor,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: a.lightColor,
                    selectedColor: a.bgColor,
                    checkmarkColor: Colors.white,
                    showCheckmark: false,
                    side: BorderSide(
                      color: isSelected ? a.bgColor : a.bgColor.withOpacity(0.3),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 2),
                    onSelected: (_) {
                      _activeAspekt = a;
                      _applyFilter(search: _searchController.text);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Trennlinie ───────────────────────────────────────────────────
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8ECF1)),

          // ── Begriffe-Liste ────────────────────────────────────────────────
          Expanded(
            child: _visibleKeys.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                    itemCount: _visibleKeys.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, i) {
                      final key = _visibleKeys[i];
                      final aspect = termAspect[key] ?? 'Funktional';
                      final aspektEnum = _aspektFromString(aspect);
                      return _GlossarCard(
                        term: key,
                        definition: abbreviations[key] ?? '',
                        aspekt: aspektEnum,
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
          Icon(Icons.search_off_rounded,
              size: 56, color: Colors.grey.shade300),
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
            'Suchbegriff anpassen oder Filter wechseln',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Aspekt _aspektFromString(String s) {
    switch (s) {
      case 'Ökonomisch': return Aspekt.oekonomisch;
      case 'Ökologisch': return Aspekt.oekologisch;
      case 'Sozial':     return Aspekt.sozial;
      default:           return Aspekt.funktional;
    }
  }
}

// ── Glossar-Karte ─────────────────────────────────────────────────────────────
class _GlossarCard extends StatefulWidget {
  final String term;
  final String definition;
  final Aspekt aspekt;

  const _GlossarCard({
    required this.term,
    required this.definition,
    required this.aspekt,
  });

  @override
  State<_GlossarCard> createState() => _GlossarCardState();
}

class _GlossarCardState extends State<_GlossarCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.aspekt.bgColor;
    final lightColor = widget.aspekt.lightColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
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
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Kopfzeile ─────────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar mit Anfangsbuchstabe
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
                    // Begriff + Aspekt-Badge
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.term,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.5,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 3),
                          _AspektBadge(aspekt: widget.aspekt),
                        ],
                      ),
                    ),
                    // Expand-Icon
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey.shade400,
                      size: 22,
                    ),
                  ],
                ),

                // ── Kurzdefinition (erste 100 Zeichen) ────────────────────
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

                // ── Vollständige Definition ───────────────────────────────
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
