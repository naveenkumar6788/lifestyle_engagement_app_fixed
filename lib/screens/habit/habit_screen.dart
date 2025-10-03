import 'package:flutter/material.dart';
import '../../widgets/glass_container.dart';
import '../../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HabitScreen extends StatefulWidget {
  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  List<dynamic> _habits = [];
  bool _loading = true;
  final _title = TextEditingController();
  final _desc = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState((){ _loading = true; });
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final res = await SupabaseService.fetchHabits(user.id);
    if (res.error == null && res.data != null) {
      _habits = List<Map<String, dynamic>>.from(res.data as List<dynamic>);
    } else {
      print('Habit fetch error: ${res.error?.message}');
    }
    setState((){ _loading = false; });
  }

  Future<void> _add() async {
    final user = Supabase.instance.client.auth.currentUser;
    final title = _title.text.trim();
    if (user == null || title.isEmpty) return;
    final res = await SupabaseService.createHabit({'user_id': user.id, 'title': title, 'description': _desc.text.trim()});
    if (res.error == null) {
      _title.clear();
      _desc.clear();
      await _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add habit')));
    }
  }

  Future<void> _toggleComplete(String id, bool completed) async {
    final res = await SupabaseService.updateHabit(id, {'completed': !completed});
    if (res.error == null) await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassContainer(
          child: Column(
            children: [
              TextField(controller: _title, decoration: InputDecoration(hintText: 'New habit title')),
              SizedBox(height: 8),
              TextField(controller: _desc, decoration: InputDecoration(hintText: 'Description (optional)')),
              SizedBox(height: 8),
              ElevatedButton(onPressed: _add, child: Text('Add habit')),
            ],
          ),
        ),
        SizedBox(height: 12),
        Expanded(
          child: _loading ? Center(child: CircularProgressIndicator()) : ListView.builder(
            itemCount: _habits.length,
            itemBuilder: (_, i) {
              final h = _habits[i] as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: GlassContainer(
                  child: ListTile(
                    title: Text(h['title'] ?? ''),
                    subtitle: Text(h['description'] ?? ''),
                    trailing: Checkbox(
                      value: h['completed'] ?? false,
                      onChanged: (_) => _toggleComplete(h['id'], h['completed'] ?? false),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
