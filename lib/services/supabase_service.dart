import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseResult {
  final dynamic data;
  final dynamic error;
  SupabaseResult({this.data, this.error});
}

class SupabaseService {
  static final _client = Supabase.instance.client;

  static Future<SupabaseResult> createOrUpdateProfile(Map<String, dynamic> profile) async {
    final res = await _client.from('profiles').upsert(profile);
    return SupabaseResult(data: res.data, error: res.error);
  }

  static Future<SupabaseResult> fetchProfile(String id) async {
    final res = await _client.from('profiles').select().eq('id', id).maybeSingle();
    return SupabaseResult(data: res.data, error: res.error);
  }

  static Future<SupabaseResult> fetchFeed() async {
    final res = await _client.from('posts').select().order('created_at', ascending: false);
    return SupabaseResult(data: res.data, error: res.error);
  }

  static Future<SupabaseResult> createPost(Map<String, dynamic> post) async {
    final res = await _client.from('posts').insert(post);
    return SupabaseResult(data: res.data, error: res.error);
  }

  static Future<SupabaseResult> fetchHabits(String userId) async {
    final res = await _client.from('habits').select().eq('user_id', userId).order('title', ascending: true);
    return SupabaseResult(data: res.data, error: res.error);
  }

  static Future<SupabaseResult> createHabit(Map<String, dynamic> habit) async {
    final res = await _client.from('habits').insert(habit);
    return SupabaseResult(data: res.data, error: res.error);
  }

  static Future<SupabaseResult> updateHabit(String id, Map<String, dynamic> patch) async {
    final res = await _client.from('habits').update(patch).eq('id', id);
    return SupabaseResult(data: res.data, error: res.error);
  }
}
