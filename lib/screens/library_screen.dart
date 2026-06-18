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
  final _sourceController = TextEditingController();
  late List<MagazineVolume> _volumes;
  bool _isSyncing = false;

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
    _loadSavedSource();
  }

  Future<void> _loadSavedSource() async {
    final source = await _catalogService.loadSavedSource();
    if (source != null && mounted) {
      _sourceController.text = source;
    }
  }

  @override
  void dispose() {
    _sourceController.dispose();
    super.dispose();
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
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavigation(
        selectedIndex: _selectedNavigation,
        onSelected: (index) {
          setState(() => _selectedNavigation = index);
          if (index == 4) {
            _showCatalogSource();
          } else if (index == 3) {
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

  void _showCatalogSource() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _surface,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            4,
            20,
            MediaQuery.viewInsetsOf(context).bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update Library',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Paste a public JSON catalog URL. The server must allow browser access (CORS).',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .62),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _sourceController,
                keyboardType: TextInputType.url,
                autocorrect: false,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Catalog JSON URL',
                  labelStyle:
                      TextStyle(color: Colors.white.withValues(alpha: .58)),
                  hintText: 'https://example.com/volumes.json',
                  hintStyle:
                      TextStyle(color: Colors.white.withValues(alpha: .3)),
                  filled: true,
                  fillColor: _background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _isSyncing
                      ? null
                      : () async {
                          setSheetState(() => _isSyncing = true);
                          try {
                            final source = _sourceController.text.trim();
                            final updated =
                                await _catalogService.fetchCatalog(source);
                            await _catalogService.saveSource(source);
                            if (!mounted) return;
                            setState(() {
                              _volumes = updated;
                              _selectedYear = null;
                              _selectedTab = 0;
                              _selectedNavigation = 1;
                              _isSyncing = false;
                            });
                            setSheetState(() {});
                            if (sheetContext.mounted) {
                              Navigator.pop(sheetContext);
                            }
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${updated.length} volumes updated.',
                                ),
                              ),
                            );
                          } catch (error) {
                            if (mounted) {
                              setState(() => _isSyncing = false);
                            }
                            setSheetState(() {});
                            if (!sheetContext.mounted) return;
                            ScaffoldMessenger.of(sheetContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  error.toString().replaceFirst(
                                        'Exception: ',
                                        '',
                                      ),
                                ),
                              ),
                            );
                          }
                        },
                  icon: _isSyncing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync_rounded),
                  label: Text(_isSyncing ? 'Updating…' : 'Update books'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _volumes = List.of(sampleLibrary);
                    _selectedYear = null;
                    _selectedNavigation = 1;
                  });
                  Navigator.pop(sheetContext);
                },
                icon: const Icon(Icons.restore_rounded),
                label: const Text('Use built-in catalog'),
              ),
            ],
          ),
        ),
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
                          left: 8,
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(6, 6, 6, 7),
                            color: const Color(0xC916120B),
                            child: Column(
                              children: [
                                const Text(
                                  'വിക്ഞാനദീപം',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFF2D58B),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  volume.title.toUpperCase(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    height: 1.15,
                                    letterSpacing: .6,
                                    fontWeight: FontWeight.w700,
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
