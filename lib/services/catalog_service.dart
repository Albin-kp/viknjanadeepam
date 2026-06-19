import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/magazine_volume.dart';

class CatalogService {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const publishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && publishableKey.isNotEmpty;

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    if (!isConfigured) return;
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: publishableKey,
    );
  }

  Future<List<MagazineVolume>> fetchPublishedVolumes() async {
    if (!isConfigured) return const [];
    final rows = await client
        .from('magazine_volumes')
        .select()
        .eq('published', true)
        .order('year', ascending: false)
        .order('volume_number', ascending: false);
    return rows.map(MagazineVolume.fromJson).toList();
  }

  Future<List<MagazineVolume>> fetchAdminVolumes() async {
    final rows = await client
        .from('magazine_volumes')
        .select()
        .order('year', ascending: false)
        .order('volume_number', ascending: false);
    return rows.map(MagazineVolume.fromJson).toList();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() => client.auth.signOut();

  bool get isSignedIn =>
      isConfigured && client.auth.currentSession?.user != null;

  String? get currentEmail => client.auth.currentUser?.email;

  Future<MagazineVolume> saveVolume(MagazineVolume volume) async {
    final payload = volume.toJson()..remove('id');
    final Map<String, dynamic> row;
    if (volume.id == null) {
      row = await client
          .from('magazine_volumes')
          .insert(payload)
          .select()
          .single();
    } else {
      row = await client
          .from('magazine_volumes')
          .update(payload)
          .eq('id', volume.id!)
          .select()
          .single();
    }
    return MagazineVolume.fromJson(row);
  }

  Future<void> deleteVolume(String id) =>
      client.from('magazine_volumes').delete().eq('id', id);
}
