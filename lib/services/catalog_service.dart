import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/magazine_volume.dart';

class CatalogService {
  static const _sourceKey = 'catalog_source_url';

  Future<String?> loadSavedSource() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_sourceKey);
  }

  Future<void> saveSource(String url) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_sourceKey, url);
  }

  Future<List<MagazineVolume>> fetchCatalog(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw const FormatException('Enter a valid public JSON URL.');
    }

    final response = await http.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('The source returned HTTP ${response.statusCode}.');
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    final rawVolumes = decoded is List<dynamic>
        ? decoded
        : (decoded as Map<String, dynamic>)['volumes'] as List<dynamic>?;

    if (rawVolumes == null || rawVolumes.isEmpty) {
      throw const FormatException('No volumes were found in this catalog.');
    }

    final volumes = rawVolumes
        .map(
          (volume) => MagazineVolume.fromJson(volume as Map<String, dynamic>),
        )
        .toList()
      ..sort((a, b) {
        final yearOrder = b.year.compareTo(a.year);
        return yearOrder == 0 ? b.number.compareTo(a.number) : yearOrder;
      });

    if (volumes.any((volume) => volume.chapters.isEmpty)) {
      throw const FormatException(
        'Every volume must include at least one chapter.',
      );
    }
    return volumes;
  }
}
