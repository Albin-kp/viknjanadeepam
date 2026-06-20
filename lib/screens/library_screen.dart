import 'package:flutter/material.dart';

import '../data/sample_library.dart';
import '../models/magazine_volume.dart';
import '../services/catalog_service.dart';
import 'reader_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  static const _background = Color(0xFF111315);
  static const _surface = Color(0xFF1D2024);
  static const _accent = Color(0xFF1495E6);

  int _selectedTab = 0;
  int _selectedNavigation = 1;
  int? _selectedYear;
  final _catalogService = CatalogService();
  late List<MagazineVolume> _volumes;

  List<int> get _years => _volumes.map((volume) => volume.year).toSet().toList()
    ..sort((a, b) => b.compareTo(a));

  List<MagazineVolume> get _visibleVolumes {
    if (_selectedTab == 1) return _volumes.take(2).toList();
    if (_selectedYear == null) return _volumes;
    return _volumes.where((volume) => volume.year == _selectedYear).toList();
  }

  @override
  void initState() {
    super.initState();
    _volumes = List.of(sampleLibrary);
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    try {
      final catalogVolumes = await _catalogService.loadVolumes();
      if (catalogVolumes.isNotEmpty && mounted) {
        setState(() {
          _volumes = catalogVolumes;
          _selectedYear = null;
        });
      }
    } catch (_) {
      // Keep the bundled catalog available when the network is unavailable.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 0),
              child: Row(
                children: [
                  const SizedBox(width: 44),
                  const Expanded(
                    child: Column(
                      children: [
                        Text(
                          'വിക്ഞാനദീപം',
                          key: Key('app-heading'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'JACOBITE HISTORY ARCHIVE',
                          style: TextStyle(
                            color: Color(0xFF90969E),
                            fontSize: 8,
                            letterSpacing: 1.35,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Filter volumes',
                    onPressed: _showYearFilter,
                    color: Colors.white,
                    icon: const Icon(Icons.tune_rounded, size: 27),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _LibraryTab(
                  label: _selectedYear == null
                      ? 'All Volumes'
                      : '${_selectedYear!}',
                  selected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _LibraryTab(
                  label: 'My Library',
                  selected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
              ],
            ),
            Container(height: 1, color: Colors.white.withValues(alpha: .08)),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadCatalog,
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(11, 14, 11, 118),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: .68,
                  ),
                  itemCount: _visibleVolumes.length,
                  itemBuilder: (context, index) {
                    final volume = _visibleVolumes[index];
                    return _VolumeTile(
                      volume: volume,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ReaderScreen(volume: volume),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavigation(
        selectedIndex: _selectedNavigation,
        onSelected: (index) {
          setState(() => _selectedNavigation = index);
          if (index == 3) {
            showSearch<void>(
              context: context,
              delegate: _VolumeSearchDelegate(_volumes),
            );
          } else if (index != 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This section will be added in the next build.'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }

  void _showYearFilter() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _surface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by year',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'All years',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: _selectedYear == null
                    ? const Icon(Icons.check, color: _accent)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedYear = null;
                    _selectedTab = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              for (final year in _years)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '$year',
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: _selectedYear == year
                      ? const Icon(Icons.check, color: _accent)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedYear = year;
                      _selectedTab = 0;
                    });
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LibraryTab extends StatelessWidget {
  const _LibraryTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                label,
                style: TextStyle(
                  color: selected
                      ? _LibraryScreenState._accent
                      : Colors.white.withValues(alpha: .74),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 105,
              height: 3,
              decoration: BoxDecoration(
                color:
                    selected ? _LibraryScreenState._accent : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VolumeTile extends StatelessWidget {
  const _VolumeTile({required this.volume, required this.onTap});

  final MagazineVolume volume;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: Key('volume-${volume.number}'),
      color: _LibraryScreenState._surface,
      borderRadius: BorderRadius.circular(13),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 13),
          child: Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/heritage-cover.png',
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 5,
                          right: 5,
                          top: 13,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(7, 6, 7, 7),
                            decoration: BoxDecoration(
                              color: const Color(0xEDF4EFE2),
                              border: Border.all(
                                color: const Color(0xFF332A1C),
                                width: .8,
                              ),
                            ),
                            child: Column(
                              children: [
                                const _LampMark(),
                                const SizedBox(height: 1),
                                const Text(
                                  'വിക്ഞാനദീപം',
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF17130E),
                                    fontSize: 12.5,
                                    height: 1,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'യാക്കോബായ സുറിയാനി ക്രിസ്ത്യൻ ചരിത്ര മാസിക',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF493E30),
                                    fontSize: 6.2,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: const Color(0xFF3A3023),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  volume.title.toUpperCase(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF17130E),
                                    fontSize: 8,
                                    height: 1.12,
                                    letterSpacing: .45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 6,
                            ),
                            color: const Color(0xDB0C1118),
                            child: Text(
                              '${volume.year}  •  VOL. ${volume.number}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFE5C477),
                                fontSize: 9,
                                letterSpacing: .7,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                volume.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VolumeSearchDelegate extends SearchDelegate<void> {
  _VolumeSearchDelegate(this.volumes);

  final List<MagazineVolume> volumes;

  @override
  ThemeData appBarTheme(BuildContext context) =>
      ThemeData.dark(useMaterial3: true);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            onPressed: () => query = '',
            icon: const Icon(Icons.close),
          ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final needle = query.toLowerCase();
    final matches = volumes.where(
      (volume) =>
          volume.title.toLowerCase().contains(needle) ||
          volume.year.toString().contains(needle) ||
          volume.number.toString().contains(needle),
    );
    return Container(
      color: _LibraryScreenState._background,
      child: ListView(
        children: matches
            .map(
              (volume) => ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                title: Text(volume.title),
                subtitle: Text('${volume.year} · Volume ${volume.number}'),
                trailing: const Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  close(context, null);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ReaderScreen(volume: volume),
                    ),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (Icons.home_outlined, 'Home'),
    (Icons.auto_stories_outlined, 'Volumes'),
    (Icons.bookmark_border_rounded, 'Bookmarks'),
    (Icons.search_rounded, 'Search'),
    (Icons.menu_rounded, 'Menu'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF17191C),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: .07)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          child: Row(
            children: List.generate(_items.length, (index) {
              final selected = selectedIndex == index;
              return Expanded(
                child: InkWell(
                  onTap: () => onSelected(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _items[index].$1,
                        color: selected
                            ? _LibraryScreenState._accent
                            : Colors.white.withValues(alpha: .4),
                        size: 27,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[index].$2,
                        style: TextStyle(
                          color: selected
                              ? _LibraryScreenState._accent
                              : Colors.white.withValues(alpha: .4),
                          fontSize: 11,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _LampMark extends StatelessWidget {
  const _LampMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      height: 31,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            top: 0,
            child: Icon(
              Icons.local_fire_department_rounded,
              size: 15,
              color: Color(0xFF17130E),
            ),
          ),
          Positioned(
            bottom: 3,
            child: Container(
              width: 18,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF17130E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 24,
              height: 2,
              color: const Color(0xFF17130E),
            ),
          ),
        ],
      ),
    );
  }
}
