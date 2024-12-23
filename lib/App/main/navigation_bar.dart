import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../home/home_page.dart';
import '../settings/settings_page.dart';
import '../account/account_page.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.myIndex});
  final int myIndex;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.myIndex;
  }

  final List<Widget> _pages = [
    const Account(),
    const HomePage(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSecondary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.account_circle_outlined,
            ),
            title: const Text('Account'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Text('Home'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.settings_outlined,
            ),
            title: const Text('Settings'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _pages[_selectedIndex],
    );
  }
}
