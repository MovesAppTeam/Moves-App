import 'package:application/screens/calendar/calendar_screen.dart';
import 'package:application/screens/chat/chat_screen.dart';
import 'package:application/screens/home_screen.dart';
import 'package:application/screens/map/map_screen.dart';
import 'package:application/screens/profile/user_profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final _pageViewController = PageController(initialPage: 3);

  int _activePage = 2;

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  int index = 3;
  final pages = [
    const MapScreen(),
    const CalendarScreen(),
    const ChatScreen(),
    const ChatScreen(),
    const UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        allowImplicitScrolling: true,
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageViewController,
        children: const <Widget>[
          MapScreen(),
          CalendarScreen(),
          ChatScreen(),
          ChatScreen(),
          UserProfile(),
        ],
        onPageChanged: (index) {
          setState(() {
            _activePage = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.white70,
          selectedItemColor: Colors.white,
          currentIndex: _activePage,
          onTap: (index) {
            _pageViewController.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceOut);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map),
                label: "Map",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                activeIcon: Icon(Icons.calendar_month),
                label: "Moves",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.whatshot_outlined),
                activeIcon: Icon(Icons.whatshot),
                label: "Explore",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined),
                activeIcon: Icon(Icons.chat_rounded),
                label: "Chat",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: "Profile",
                backgroundColor: Colors.black),
          ]),
    );
  }
}
