import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass_container.dart';
import '../feed/feed_screen.dart';
import '../habit/habit_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _pages = [FeedScreen(), HabitScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lifestyle & Engagement'),
        actions: [
          IconButton(onPressed: () => auth.signOut(), icon: Icon(Icons.logout)),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _pages[_index],
      ),
      bottomNavigationBar: GlassContainer(
        borderRadius: 0,
        padding: EdgeInsets.zero,
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (v) => setState(() => _index = v),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
            BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Habits'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
