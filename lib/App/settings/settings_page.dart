import 'package:accident_tracker/App/settings/language_page.dart';
import 'package:accident_tracker/App/settings/privacy_policy_page.dart';
import 'package:accident_tracker/config/routes/theme_provider.dart';
import 'package:accident_tracker/App/settings/about_us_page.dart';
import 'package:accident_tracker/App/settings/feedback_page.dart';
import 'package:accident_tracker/App/settings/contact_page.dart';
import 'package:accident_tracker/App/settings/rating_page.dart';
import 'package:accident_tracker/App/settings/share_page.dart';
import 'package:accident_tracker/App/settings/terms_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:accident_tracker/common/Widgets/my_textfield.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../main/navigation_bar.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;
  bool loaded = false;

  @override
  void initState() {
    _loadSettings();
    super.initState();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool('dark_mode') ?? false;
      loaded = true;
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isSwitched);
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.surface;
    final Color textColor = Theme.of(context).colorScheme.primary;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(myIndex: 1),
          ),
        );
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(color: textColor),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDarkModeSwitch(textColor),
                    _buildMenuOptions(textColor),
                    _buildDeveloperContact(textColor),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDarkModeSwitch(Color textColor) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(11.0),
      ),
      child: ListTile(
        tileColor: Colors.transparent,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        leading: const Icon(Icons.dark_mode_outlined),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dark Mode',
                style: TextStyle(color: textColor),
              ),
              loaded
                  ? Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                        if (mounted) {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme();
                        }
                        _saveSettings();
                      },
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOptions(Color textColor) {
    return Column(
      children: [
        _buildMenuItem(
            Icons.star_border, 'Rate App', const RatingPage(), textColor),
        _buildMenuItem(
            Icons.language, 'Language Select', const LanguagePage(), textColor),
        _buildMenuItem(
            Icons.share_outlined, 'Share App', const ShareApp(), textColor),
        _buildMenuItem(Icons.lock_outlined, 'Privacy Policy',
            const PrivacyPolicy(), textColor),
        _buildMenuItem(Icons.info_outline, 'Terms and Conditions',
            const Terms(), textColor),
        _buildMenuItem(Icons.mail, 'Contact', const Contact(), textColor),
        _buildMenuItem(
            Icons.message_outlined, 'Feedback', const MyFeedback(), textColor),
        _buildMenuItem(Icons.info, 'About Us', const AboutUsPage(), textColor),
      ],
    );
  }

  Widget _buildMenuItem(
      IconData icon, String title, Widget page, Color textColor) {
    return MyLabel(
      icon: icon,
      color: Theme.of(context).colorScheme.onPrimary,
      context: context,
      msg: title,
      msgStyle: TextStyle(color: textColor),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  Widget _buildDeveloperContact(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'To contact Developer:',
          style: TextStyle(color: textColor),
        ),
        TextButton(
          onPressed: () async {
            final Uri updateUrl =
                Uri(scheme: 'https', host: 'guns.lol', path: '/kaiowa');
            if (await canLaunchUrl(updateUrl)) {
              await launchUrl(updateUrl);
            } else {
              print('Could not launch the provided URL.');
            }
          },
          child: const Text(
            'Click Here',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 153, 0, 255),
            ),
          ),
        ),
      ],
    );
  }
}
