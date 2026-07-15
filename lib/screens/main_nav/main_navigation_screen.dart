import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../search/explore_tab.dart';
import '../bookings/my_bookings_screen.dart';
import '../chat/messages_tab.dart';
import '../profile/profile_screen.dart';

/// Hosts the five bottom-nav tabs behind a single Scaffold, matching
/// the "Bottom Navigation (5 Tabs)" structure from the navigation spec:
/// Home / Explore / Bookings / Messages / Profile — each reachable
/// from any other tab without losing its own back-stack.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

  static const _tabs = [
    HomeTab(),
    ExploreTab(),
    MyBookingsTab(),
    MessagesTab(),
    ProfileScreen(embedded: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
