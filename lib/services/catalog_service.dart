import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/magazine_volume.dart';

class CatalogService {
  Future<List<MagazineVolume>> loadVolumes() async {
    final source = await rootBundle.loadString('assets/data/catalog.json');
    final rows = jsonDecode(source) as List<dynamic>;
    final volumes = rows
        .map(
          (row) => MagazineVolume.fromJson(row as Map<String, dynamic>),
        )
        .toList();
    volumes.sort((a, b) {
      final yearOrder = b.year.compareTo(a.year);
      return yearOrder != 0 ? yearOrder : b.number.compareTo(a.number);
    });
    return volumes.where((volume) => volume.published).toList();
  }
}
