import 'package:flutter/material.dart';
import '../../widgets/glass_container.dart';
import '../../services/supabase_service.dart';

class FeedScreen extends StatefulWidget {
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<dynamic> _posts = [];
  bool _loading = true;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; });
    final res = await SupabaseService.fetchFeed();
    if (res.error == null && res.data != null) {
      _posts = List<Map<String, dynamic>>.from(res.data as List<dynamic>);
    }
    setState(() { _loading = false; });
  }

  Future<void> _createPost() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final post = {
      'content': text,
    };
    final res = await SupabaseService.createPost(post);
    if (res.error == null) {
      _controller.clear();
      await _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create post')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassContainer(
          child: Row(
            children: [
              Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: 'Share something...'))),
              IconButton(onPressed: _createPost, icon: Icon(Icons.send))
            ],
          ),
        ),
        SizedBox(height: 12),
        Expanded(
          child: _loading ? Center(child: CircularProgressIndicator()) : ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (_, i) {
              final p = _posts[i] as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['content'] ?? '', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Likes: ${p['likes'] ?? 0}"),
                          Text(p['created_at'] ?? '')
                        ],
                      ),
                    ],
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
