import 'package:flutter/material.dart';
import 'package:dr_tragic_mfa/presentation/screens/home/home_screen.dart';
import 'package:dr_tragic_mfa/presentation/screens/bookmarks/bookmark_screen.dart';
import 'package:dr_tragic_mfa/presentation/screens/progress/progress_dashboard_screen.dart';
import 'package:dr_tragic_mfa/presentation/screens/settings/settings_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        
        Widget screen;
        switch (index) {
          case 0:
            screen = const HomeScreen();
            break;
          case 1:
            screen = const BookmarkScreen();
            break;
          case 2:
            screen = const HomeScreen(); // Mock Test placeholder
            break;
          case 3:
            screen = const ProgressDashboardScreen();
            break;
          case 4:
            screen = const SettingsScreen();
            break;
          default:
            screen = const HomeScreen();
        }
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Bookmarks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Mock Test',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Progress',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
