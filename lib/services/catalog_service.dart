import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/magazine_volume.dart';

class CatalogService {
  static const _buildVersion = String.fromEnvironment(
    'BUILD_VERSION',
    defaultValue: 'local',
  );

  Future<List<MagazineVolume>> loadVolumes() async {
    final String source;
    if (kIsWeb) {
      final response = await http.get(
        Uri.base.resolve(
          'assets/assets/data/catalog.json?v=$_buildVersion',
        ),
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Catalogue request failed: ${response.statusCode}',
        );
      }
      source = utf8.decode(response.bodyBytes);
    } else {
      source = await rootBundle.loadString('assets/data/catalog.json');
    }
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
