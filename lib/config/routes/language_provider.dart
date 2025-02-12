import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  late Locale _currentLocale; // Use 'late' to initialize after loading
  bool loaded = false;

  LanguageProvider() {
    _loadSettings(); // Load the language preference on initialization
  }

  Locale get currentLocale => _currentLocale;

  // Load the stored language setting and update the locale
  Future<void> _loadSettings() async {
    bool isArabic =
        await SettingsStorage.loadBoolSetting('isArabic', defaultValue: false);
    _currentLocale = isArabic ? const Locale('ar') : const Locale('en');
    loaded = true;
    notifyListeners(); // Notify listeners that the locale is loaded
  }

  // Toggle the language and save the updated setting
  void toggleLanguage() async {
    bool isArabic =
        _currentLocale.languageCode == 'en'; // Toggle between 'en' and 'ar'
    _currentLocale = isArabic ? const Locale('ar') : const Locale('en');
    await SettingsStorage.saveBoolSetting(
        'isArabic', isArabic); // Save the updated language setting
    notifyListeners(); // Notify listeners about the language change
  }
}

class SettingsStorage {
  // Load a boolean value from SharedPreferences
/*************  ✨ Codeium Command ⭐  *************/
/******  6209654f-80d4-4e0d-ad14-e19bb9c24be9  *******/
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
