import 'package:flutter/material.dart';
import 'package:accident_tracker/config/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool isSwitched = false;
  ThemeData _themeData = lightMode;

  ThemeProvider() {
    _loadSettings(); // Load the theme preference on initialization
  }

  ThemeData get themeData => _themeData;

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSwitched = prefs.getBool('dark_mode') ?? false; // Check stored preference
    _themeData =
        isSwitched ? darkMode : lightMode; // Set theme based on dark_mode value
    notifyListeners(); // Notify listeners when theme is loaded
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSwitched = !isSwitched; // Toggle the current theme
    _themeData = isSwitched ? darkMode : lightMode;
    await prefs.setBool('dark_mode', isSwitched); // Store the new preference
    notifyListeners();
  }
}
