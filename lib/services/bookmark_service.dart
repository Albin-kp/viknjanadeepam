import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/magazine_volume.dart';

class BookmarkService extends ChangeNotifier {
  BookmarkService._();

  static final instance = BookmarkService._();
  static const _storageKey = 'bookmarked_volume_ids';

  final Set<String> _bookmarkedIds = {};
  bool _loaded = false;

  String keyFor(MagazineVolume volume) =>
      '${volume.year}-${volume.number}';

  bool contains(MagazineVolume volume) =>
      _bookmarkedIds.contains(keyFor(volume));

  Future<void> load() async {
    if (_loaded) return;
    final preferences = await SharedPreferences.getInstance();
    _bookmarkedIds
      ..clear()
      ..addAll(preferences.getStringList(_storageKey) ?? const []);
    _loaded = true;
    notifyListeners();
  }

  Future<void> toggle(MagazineVolume volume) async {
    await load();
    final key = keyFor(volume);
    if (!_bookmarkedIds.add(key)) {
      _bookmarkedIds.remove(key);
    }
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _storageKey,
      _bookmarkedIds.toList()..sort(),
    );
  }
}
