import 'package:flutter/material.dart';

import '../main.dart';
import '../models/magazine_volume.dart';
import '../services/bookmark_service.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, required this.volume});

  final MagazineVolume volume;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _scrollController = ScrollController();
  final _chapterKeys = <GlobalKey>[];
  double _progress = 0;
  double _fontSize = 18;
  final _bookmarkService = BookmarkService.instance;

  bool get _bookmarked => _bookmarkService.contains(widget.volume);

  @override
  void initState() {
    super.initState();
    _chapterKeys.addAll(
      List.generate(widget.volume.chapters.length, (_) => GlobalKey()),
    );
    _scrollController.addListener(_updateProgress);
    _bookmarkService
      ..addListener(_refreshBookmark)
      ..load();
  }

  void _refreshBookmark() {
    if (mounted) setState(() {});
  }

  void _updateProgress() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    setState(() {
      _progress = max == 0 ? 0 : (_scrollController.offset / max).clamp(0, 1);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateProgress)
      ..dispose();
    _bookmarkService.removeListener(_refreshBookmark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: VijnanaDeepamApp.paper.withValues(alpha: .96),
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.volume.year} · Volume ${widget.volume.number}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '${(_progress * 100).round()}% read',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: VijnanaDeepamApp.ink.withValues(alpha: .58),
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Contents',
            onPressed: _showContents,
            icon: const Icon(Icons.list_rounded),
          ),
          IconButton(
            tooltip: 'Reading settings',
            onPressed: _showReadingSettings,
            icon: const Icon(Icons.text_fields_rounded),
          ),
          IconButton(
            tooltip: _bookmarked ? 'Remove bookmark' : 'Bookmark',
            onPressed: () => _bookmarkService.toggle(widget.volume),
            icon: Icon(
              _bookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 3,
            color: VijnanaDeepamApp.saffron,
            backgroundColor: VijnanaDeepamApp.forest.withValues(alpha: .1),
          ),
        ),
      ),
      body: SelectionArea(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(24, 44, 24, 90),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.volume.title,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.volume.subtitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: VijnanaDeepamApp.ink.withValues(alpha: .62),
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 34),
                    const Divider(
                        color: VijnanaDeepamApp.saffron, thickness: 2),
                    const SizedBox(height: 24),
                    for (var index = 0;
                        index < widget.volume.chapters.length;
                        index++)
                      _ChapterSection(
                        key: _chapterKeys[index],
                        chapter: widget.volume.chapters[index],
                        fontSize: _fontSize,
                      ),
                    const Center(
                      child: Icon(
                        Icons.auto_stories_rounded,
                        color: VijnanaDeepamApp.saffron,
                      ),
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

  void _showContents() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contents',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              for (var index = 0;
                  index < widget.volume.chapters.length;
                  index++)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text('${index + 1}'.padLeft(2, '0')),
                  title: Text(widget.volume.chapters[index].title),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onTap: () {
                    Navigator.pop(context);
                    Scrollable.ensureVisible(
                      _chapterKeys[index].currentContext!,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      alignment: .08,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReadingSettings() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reading settings',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Text('A', style: TextStyle(fontSize: 14)),
                    Expanded(
                      child: Slider(
                        value: _fontSize,
                        min: 16,
                        max: 24,
                        divisions: 4,
                        onChanged: (value) {
                          setState(() => _fontSize = value);
                          setSheetState(() {});
                        },
                      ),
                    ),
                    const Text('A', style: TextStyle(fontSize: 24)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChapterSection extends StatelessWidget {
  const _ChapterSection({
    super.key,
    required this.chapter,
    required this.fontSize,
  });

  final MagazineChapter chapter;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chapter.kicker.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: VijnanaDeepamApp.saffron,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            chapter.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 30,
                  height: 1.18,
                ),
          ),
          const SizedBox(height: 22),
          for (final paragraph in chapter.paragraphs)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                paragraph,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Georgia',
                      fontSize: fontSize,
                      height: 1.78,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
