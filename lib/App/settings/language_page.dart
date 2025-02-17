import 'package:accident_tracker/config/routes/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/Widgets/my_label.dart';
import '../main/navigation_bar.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLanguage = 'en';
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = (prefs.getBool('isArabic') ?? false) ? 'ar' : 'en';
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Language'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(myIndex: 2),
              ),
            );
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'choose Language',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: loaded,
              child: Column(
                children: [
                  myLabel(
                    context: context,
                    color: Theme.of(context).colorScheme.primary,
                    trailing: Radio(
                      value: 'en',
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = 'en';
                          Provider.of<LanguageProvider>(context, listen: false)
                              .toggleLanguage(selectedLanguage);
                        });
                      },
                    ),
                    leading: CountryFlag.fromLanguageCode(
                      'en-US',
                      height: 30,
                      width: 30,
                      shape: const RoundedRectangle(8),
                    ),
                    msg: 'English',
                    onTap: () {
                      setState(() {
                        selectedLanguage = 'en';
                        Provider.of<LanguageProvider>(context, listen: false)
                            .toggleLanguage(selectedLanguage);
                      });
                    },
                  ),
                  myLabel(
                    context: context,
                    color: Theme.of(context).colorScheme.primary,
                    trailing: Radio(
                      value: 'ar',
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = 'ar';
                          Provider.of<LanguageProvider>(context, listen: false)
                              .toggleLanguage(selectedLanguage);
                        });
                      },
                    ),
                    leading: CountryFlag.fromLanguageCode(
                      'ar-EG',
                      height: 30,
                      width: 30,
                      shape: const RoundedRectangle(8),
                    ),
                    msg: 'Arabic',
                    onTap: () {
                      setState(() {
                        selectedLanguage = 'ar';
                        Provider.of<LanguageProvider>(context, listen: false)
                            .toggleLanguage(selectedLanguage);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
