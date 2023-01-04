import 'package:application/screens/calendar/calendar_screen.dart';
import 'package:application/screens/chat/chat_screen.dart';
import 'package:application/screens/explore/explore_screen.dart';
import 'package:application/screens/home_screen.dart';
import 'package:application/screens/map/map_screen.dart';
import 'package:application/screens/profile/user_profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key, required this.page}) : super(key: key);
  final int page;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late int pageNum = widget.page;
  late final _pageViewController = PageController(initialPage: pageNum);

  late int _activePage = pageNum;

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

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
          ExploreScreen(),
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
                curve: Curves.easeInOutCubicEmphasized);
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
