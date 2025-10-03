import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/glass_container.dart';
import '../../services/supabase_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  final _username = TextEditingController();
  final _fullname = TextEditingController();
  final _bio = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState((){ _loading = true; });
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final res = await SupabaseService.fetchProfile(user.id);
    if (res.error == null && res.data != null) {
      _profile = Map<String, dynamic>.from(res.data as Map);
      _username.text = _profile?['username'] ?? '';
      _fullname.text = _profile?['full_name'] ?? '';
      _bio.text = _profile?['bio'] ?? '';
    }
    setState((){ _loading = false; });
  }

  Future<void> _save() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final payload = {
      'id': user.id,
      'username': _username.text.trim(),
      'full_name': _fullname.text.trim(),
      'bio': _bio.text.trim(),
    };
    final res = await SupabaseService.createOrUpdateProfile(payload);
    if (res.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved')));
      await _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save profile')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Center(child: CircularProgressIndicator());
    return SingleChildScrollView(
      child: Column(
        children: [
          GlassContainer(
            child: Column(
              children: [
                CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
                SizedBox(height: 12),
                TextField(controller: _username, decoration: InputDecoration(labelText: 'Username')),
                SizedBox(height: 8),
                TextField(controller: _fullname, decoration: InputDecoration(labelText: 'Full name')),
                SizedBox(height: 8),
                TextField(controller: _bio, decoration: InputDecoration(labelText: 'Bio')),
                SizedBox(height: 12),
                ElevatedButton(onPressed: _save, child: Text('Save profile')),
              ],
            ),
          ),
          SizedBox(height: 12),
          GlassContainer(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Points: \${_profile?['points'] ?? 0}"),
              SizedBox(height: 8),
              Text("Member since: \${_profile?['created_at'] ?? ''}"),
            ],
          )),
        ],
      ),
    );
  }
}
