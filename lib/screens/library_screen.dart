import 'package:flutter/material.dart';

import '../data/sample_library.dart';
import '../main.dart';
import '../models/magazine_volume.dart';
import 'reader_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late int selectedYear;

  List<int> get years =>
      sampleLibrary.map((volume) => volume.year).toSet().toList()
        ..sort((a, b) => b.compareTo(a));

  @override
  void initState() {
    super.initState();
    selectedYear = years.first;
  }

  @override
  Widget build(BuildContext context) {
    final volumes =
        sampleLibrary.where((volume) => volume.year == selectedYear).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const _BrandMark(),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Search archive',
                            onPressed: () => showSearch<void>(
                              context: context,
                              delegate: _VolumeSearchDelegate(),
                            ),
                            icon: const Icon(Icons.search_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 42),
                      Text(
                        'Annual Archive',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Choose a year, open a volume, and continue the conversation.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color:
                                  VijnanaDeepamApp.ink.withValues(alpha: .66),
                            ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'SELECT YEAR',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  letterSpacing: 1.8,
                                  fontWeight: FontWeight.w700,
                                  color: VijnanaDeepamApp.forest,
                                ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: years
                              .map(
                                (year) => Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ChoiceChip(
                                    label: Text('$year'),
                                    selected: selectedYear == year,
                                    showCheckmark: false,
                                    onSelected: (_) =>
                                        setState(() => selectedYear = year),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.crossAxisExtent > 760 ? 2 : 1;
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: columns == 1 ? 1.28 : 1.38,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _VolumeCard(
                        volume: volumes[index],
                        onOpen: () => _openVolume(context, volumes[index]),
                      ),
                      childCount: volumes.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openVolume(BuildContext context, MagazineVolume volume) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => ReaderScreen(volume: volume)),
  );
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: VijnanaDeepamApp.forest,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: VijnanaDeepamApp.paper,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Vijnana Deepam',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class _VolumeCard extends StatelessWidget {
  const _VolumeCard({required this.volume, required this.onOpen});

  final MagazineVolume volume;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .72),
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: VijnanaDeepamApp.forest,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VIJNANA\nDEEPAM',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: VijnanaDeepamApp.paper,
                            letterSpacing: 2,
                            height: 1.3,
                          ),
                    ),
                    const Spacer(),
                    Container(
                      width: 28,
                      height: 3,
                      color: VijnanaDeepamApp.saffron,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      volume.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: VijnanaDeepamApp.paper,
                            height: 1.12,
                          ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${volume.year}  •  VOL. ${volume.number}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                VijnanaDeepamApp.paper.withValues(alpha: .68),
                            letterSpacing: 1.2,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Volume ${volume.number}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: VijnanaDeepamApp.saffron,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      volume.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        volume.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  VijnanaDeepamApp.ink.withValues(alpha: .68),
                            ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded, size: 17),
                        const SizedBox(width: 6),
                        Text('${volume.readingMinutes} min'),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VolumeSearchDelegate extends SearchDelegate<void> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
              onPressed: () => query = '', icon: const Icon(Icons.close)),
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
    final matches = sampleLibrary.where((volume) {
      final needle = query.toLowerCase();
      return volume.title.toLowerCase().contains(needle) ||
          volume.year.toString().contains(needle);
    });
    return ListView(
      children: matches
          .map(
            (volume) => ListTile(
              title: Text(volume.title),
              subtitle: Text('${volume.year} · Volume ${volume.number}'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                close(context, null);
                _openVolume(context, volume);
              },
            ),
          )
          .toList(),
    );
  }
}
