import 'package:flutter/material.dart';

import '../data/sample_library.dart';
import '../models/magazine_volume.dart';
import '../services/bookmark_service.dart';
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
  int _selectedNavigation = 0;
  int? _selectedYear;
  final _catalogService = CatalogService();
  final _bookmarkService = BookmarkService.instance;
  late List<MagazineVolume> _volumes;

  List<int> get _years => _volumes.map((volume) => volume.year).toSet().toList()
    ..sort((a, b) => b.compareTo(a));

  List<MagazineVolume> get _visibleVolumes {
    if (_selectedTab == 1 || _selectedNavigation == 1) {
      return _volumes.where(_bookmarkService.contains).toList();
    }
    if (_selectedYear == null) return _volumes;
    return _volumes.where((volume) => volume.year == _selectedYear).toList();
  }

  @override
  void initState() {
    super.initState();
    _volumes = List.of(sampleLibrary);
    _bookmarkService
      ..addListener(_refreshBookmarks)
      ..load();
    _loadCatalog();
  }

  void _refreshBookmarks() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bookmarkService.removeListener(_refreshBookmarks);
    super.dispose();
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
    } catch (error, stackTrace) {
      debugPrint('Could not load magazine catalogue: $error');
      debugPrintStack(stackTrace: stackTrace);
      // Keep the bundled catalog available when the network is unavailable.
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 430;
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 14 : 20,
                compact ? 12 : 18,
                compact ? 8 : 12,
                0,
              ),
              child: Row(
                children: [
                  SizedBox(width: compact ? 38 : 44),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'വിക്ഞാനദീപം',
                          key: Key('app-heading'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 21 : 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'JACOBITE HISTORY ARCHIVE',
                          style: TextStyle(
                            color: const Color(0xFF90969E),
                            fontSize: compact ? 6.5 : 8,
                            letterSpacing: compact ? 1.05 : 1.35,
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
                    icon: Icon(
                      Icons.tune_rounded,
                      size: compact ? 24 : 27,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: compact ? 12 : 20),
            Row(
              children: [
                _LibraryTab(
                  label: _selectedYear == null
                      ? 'All Volumes'
                      : '${_selectedYear!}',
                  selected: _selectedTab == 0,
                  onTap: () => setState(() {
                    _selectedTab = 0;
                    _selectedNavigation = 0;
                  }),
                  compact: compact,
                ),
                _LibraryTab(
                  label: 'Bookmarks',
                  selected: _selectedTab == 1,
                  onTap: () => setState(() {
                    _selectedTab = 1;
                    _selectedNavigation = 1;
                  }),
                  compact: compact,
                ),
              ],
            ),
            Container(height: 1, color: Colors.white.withValues(alpha: .08)),
            Expanded(
              child: _visibleVolumes.isEmpty &&
                      (_selectedTab == 1 || _selectedNavigation == 1)
                  ? const _EmptyBookmarks()
                  : RefreshIndicator(
                      onRefresh: _loadCatalog,
                      child: GridView.builder(
                        padding: EdgeInsets.fromLTRB(
                          compact ? 8 : 11,
                          compact ? 10 : 14,
                          compact ? 8 : 11,
                          compact ? 92 : 118,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: compact ? 10 : 14,
                          crossAxisSpacing: compact ? 10 : 14,
                          childAspectRatio: compact ? .7 : .68,
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
          if (index == 2) {
            showSearch<void>(
              context: context,
              delegate: _VolumeSearchDelegate(_volumes),
            );
            return;
          }
          setState(() {
            _selectedNavigation = index;
            _selectedTab = index == 1 ? 1 : 0;
          });
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
                    _selectedNavigation = 0;
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
                      _selectedNavigation = 0;
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

class _EmptyBookmarks extends StatelessWidget {
  const _EmptyBookmarks();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_add_outlined,
              size: 54,
              color: Colors.white.withValues(alpha: .34),
            ),
            const SizedBox(height: 16),
            const Text(
              'No bookmarks yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Open a volume and tap the bookmark icon to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: .55),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
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
    required this.compact,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: compact ? 9 : 12),
              child: Text(
                label,
                style: TextStyle(
                  color: selected
                      ? _LibraryScreenState._accent
                      : Colors.white.withValues(alpha: .74),
                  fontSize: compact ? 15 : 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: compact ? 82 : 105,
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
    final compact = MediaQuery.sizeOf(context).width <= 430;
    return Material(
      key: Key('volume-${volume.number}'),
      color: _LibraryScreenState._surface,
      borderRadius: BorderRadius.circular(13),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            compact ? 8 : 12,
            compact ? 10 : 16,
            compact ? 8 : 12,
            compact ? 9 : 13,
          ),
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
                          left: compact ? 3 : 5,
                          right: compact ? 3 : 5,
                          top: compact ? 8 : 13,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              compact ? 4 : 7,
                              compact ? 3 : 6,
                              compact ? 4 : 7,
                              compact ? 4 : 7,
                            ),
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: Image.asset(
                                        'assets/images/vijnanadeepam-logo.png',
                                        width: compact ? 22 : 29,
                                        height: compact ? 22 : 29,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: compact ? 3 : 4),
                                    Flexible(
                                      child: Text(
                                        'വിക്ഞാനദീപം',
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF080604),
                                          fontSize: compact ? 9.5 : 12.8,
                                          height: 1,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: compact ? 2 : 3),
                                Text(
                                  'യാക്കോബായ സുറിയാനി ക്രിസ്ത്യൻ ചരിത്ര മാസിക',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF120C07),
                                    fontSize: compact ? 4.8 : 6.2,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: compact ? 3 : 5),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: const Color(0xFF3A3023),
                                ),
                                SizedBox(height: compact ? 3 : 4),
                                Text(
                                  volume.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF070504),
                                    fontSize: compact ? 8.3 : 11,
                                    height: 1.08,
                                    letterSpacing: .1,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: compact ? 6 : 8,
                          right: compact ? 6 : 8,
                          bottom: compact ? 6 : 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: compact ? 5 : 7,
                              vertical: compact ? 4 : 6,
                            ),
                            color: const Color(0xDB0C1118),
                            child: Text(
                              '${volume.year}  •  VOL. ${volume.number}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFE5C477),
                                fontSize: compact ? 7.2 : 9,
                                letterSpacing: compact ? .45 : .7,
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
              SizedBox(height: compact ? 8 : 12),
              Text(
                volume.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 12.5 : 15,
                  height: compact ? 1.12 : 1.18,
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
    (Icons.auto_stories_outlined, 'Volumes'),
    (Icons.bookmark_border_rounded, 'Bookmarks'),
    (Icons.search_rounded, 'Search'),
  ];

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 430;
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
          height: compact ? 60 : 70,
          child: Row(
            children: List.generate(_items.length, (index) {
              final selected = selectedIndex == index;
              return Expanded(
                child: InkWell(
                  key: Key('nav-${_items[index].$2.toLowerCase()}'),
                  onTap: () => onSelected(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _items[index].$1,
                        color: selected
                            ? _LibraryScreenState._accent
                            : Colors.white.withValues(alpha: .4),
                        size: compact ? 23 : 27,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[index].$2,
                        style: TextStyle(
                          color: selected
                              ? _LibraryScreenState._accent
                              : Colors.white.withValues(alpha: .4),
                          fontSize: compact ? 9.5 : 11,
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
