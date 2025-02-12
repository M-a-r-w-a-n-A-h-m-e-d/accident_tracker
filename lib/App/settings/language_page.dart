import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';

import '../../common/Widgets/my_label.dart';
import '../main/navigation_bar.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLanguage = 'en';

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
            myLabel(
              context: context,
              color: Theme.of(context).colorScheme.primary,
              trailing: Radio(
                value: 'en',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = 'en';
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
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
