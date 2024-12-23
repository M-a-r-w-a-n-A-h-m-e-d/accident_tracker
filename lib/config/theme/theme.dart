import 'package:flutter/material.dart';

// Light Theme
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100,
    primary: Colors.blue, // Primary color for the app
    onPrimary: Colors.white, // Text color on primary
    secondary: Colors.amber, // Secondary color
    onSecondary: Colors.black, // Text color on secondary
  ),
  primaryColor: Colors.grey.shade300,
  secondaryHeaderColor: Colors.grey.shade200,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // Default body text
    bodyMedium: TextStyle(color: Colors.black54), // Secondary text
    displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Headline
  ),
);

// Dark Theme
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.blue, // Primary color for the app
    onPrimary: Colors.black, // Text color on primary
    secondary: Colors.deepOrange, // Secondary color
    onSecondary: Colors.white, // Text color on secondary
  ),
  primaryColor: Colors.grey.shade900,
  secondaryHeaderColor: Colors.grey.shade700,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // Default body text
    bodyMedium: TextStyle(color: Colors.white70), // Secondary text
    displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Headline
  ),
);
