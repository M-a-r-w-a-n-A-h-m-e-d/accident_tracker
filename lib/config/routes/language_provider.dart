import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  late Locale _currentLocale; // Use 'late' to initialize after loading
  bool loaded = false;

  LanguageProvider() {
    loadSettings(); // Load the language preference on initialization
  }

  Locale get currentLocale => _currentLocale;

  // Load the stored language setting and update the locale
  Future<void> loadSettings() async {
    bool isArabic =
        await SettingsStorage.loadBoolSetting('isArabic', defaultValue: false);
    _currentLocale = isArabic ? const Locale('ar') : const Locale('en');
    loaded = true;
    notifyListeners(); // Notify listeners that the locale is loaded
  }

  // Toggle the language and save the updated setting
  void toggleLanguage(String locale) async {
    // Set the new locale based on the passed parameter
    _currentLocale = locale == 'ar' ? const Locale('ar') : const Locale('en');

    // Determine if the selected language is Arabic
    bool isArabic = locale == 'ar';

    // Save the language preference in SharedPreferences
    await SettingsStorage.saveBoolSetting('isArabic', isArabic);
    log(isArabic.toString());
    // Notify listeners that the locale has been changed
    notifyListeners();
  }
}

class SettingsStorage {
  // Load a boolean value from SharedPreferences


  static Future<bool> loadBoolSetting(String key,
      {bool defaultValue = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  // Save a boolean value to SharedPreferences
  static Future<void> saveBoolSetting(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
