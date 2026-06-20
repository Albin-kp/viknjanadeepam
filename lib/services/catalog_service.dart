import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/magazine_volume.dart';

class CatalogService {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const publishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static bool get isConfigured {
    final uri = Uri.tryParse(supabaseUrl);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host.endsWith('.supabase.co') &&
        publishableKey.length > 20;
  }

  Future<List<MagazineVolume>> fetchPublishedVolumes() async {
    if (!isConfigured) return const [];

    final uri = Uri.parse(
      '$supabaseUrl/rest/v1/magazine_volumes'
      '?select=*&published=eq.true'
      '&order=year.desc,volume_number.desc',
    );
    final response = await http.get(
      uri,
      headers: {
        'apikey': publishableKey,
        'Authorization': 'Bearer $publishableKey',
      },
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Catalog request failed: ${response.statusCode}');
    }
    final rows = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return rows
        .map(
          (row) => MagazineVolume.fromJson(row as Map<String, dynamic>),
        )
        .toList();
  }
}
