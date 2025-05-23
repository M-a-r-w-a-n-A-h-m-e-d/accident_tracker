import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:accident_tracker/App/main/welcome_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/database.dart';
import 'package:flutter/material.dart';
import '../auth/auth_page.dart';
import '../../flavors.dart';
import 'dart:async';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  // final shorebirdCodePush = ShorebirdCodePush();
  bool _showCards = false;
  bool isDark = false;
  bool _initialized = false;
  bool _isFirstLaunch = true;
  bool _haveUpgrade = false;

  @override
  void initState() {
    super.initState();
    DataBase(name: '', email: '', password: '').createTables();
    _loadSettings();
    _checkFirstLaunch();
    F.appFlavor == Flavor.unit ? unitIdFunc() : null;
    // _initializeShorebird();
  }

  // Future<void> _initializeShorebird() async {
  //   await shorebirdCodePush.currentPatchNumber();
  //   await _checkFirstLaunch();
  // }

  Future<void> unitIdFunc() async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        log('No user is currently logged in');
        return; // Exit if no user is logged in
      }
      // Fetch user data from the database
      var result = await DataBase(
              email: user.providerData[0].email ?? '', password: 'password')
          .searchWithEmail(user.providerData[0].email ?? '');

      if (result!.isEmpty) {
        log('User data not found in the database');
        return; // Exit if no data found for the user
      }
      log(result[0][0].toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('unit_Id', (result[0][0]).toString());
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    if (_isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
    }
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.wait([_permissionsHandler(), _checkForUpdate()]);
    } catch (e) {
      log('Initialization error: $e');
    }
  }

  // Function to handle and request location and camera permissions
  Future<void> _permissionsHandler() async {
    // Request location permission from the user
    final status = await Permission.location.request();

    // Request camera permission from the user
    final status1 = await Permission.camera.request();

    // Check if either the location or camera permission is not granted
    if (!status.isGranted || !status1.isGranted) {
      // If permissions are denied, show an error message to the user
      _showErrorMessage(
          'Application will not work completely without permission.');
    }
  }

  Future<void> _checkForUpdate() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await remoteConfig.fetchAndActivate();

      var mainVersion = remoteConfig.getString('latest_version');
      var latestVersion = mainVersion.split(',');
      var finalVersion = '1';
      F.appFlavor == Flavor.unit
          ? finalVersion = latestVersion[2]
          : F.appFlavor == Flavor.development
              ? finalVersion = latestVersion[1]
              : F.appFlavor == Flavor.staging
                  ? finalVersion = latestVersion[3]
                  : finalVersion = latestVersion[0];
      latestVersion = finalVersion.split(':');
      finalVersion = latestVersion[1];
      finalVersion = finalVersion.replaceAll('"', '');
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      if (mounted) {
        setState(() {
          _haveUpgrade = currentVersion != finalVersion;
        });
      }
      if (_haveUpgrade) {
        _showUpdateDialog();
      } else {
        _navigateToNextPage();
      }
    } catch (e) {
      Sentry.captureException(e);
      print('Error fetching remote config: $e');
      await Future.delayed(const Duration(seconds: 8));
      _checkForUpdate();
    }
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('dark_mode') ?? false;
    });
  }

  void _navigateToNextPage() {
    if (_initialized) {
      if (_haveUpgrade) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      Future.delayed(const Duration(seconds: 5)).then(
        (_) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthPage(),
          ),
        ),
      );
    } else {
      if (mounted) {
        setState(() {
          _showCards = _isFirstLaunch;
          _initialized = true;
        });
      }
      if (_haveUpgrade) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      Future.delayed(const Duration(seconds: 5)).then(
        (_) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => _showCards ? const Cards() : const AuthPage(),
          ),
        ),
      );
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Update Available',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          content: Text(
              'A new version of the app is available. Please update to the latest version.',
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
          actions: [
            TextButton(
              onPressed: _navigateToNextPage,
              child: Text('Later',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
            TextButton(
              onPressed: launchURL,
              child: Text('Update',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  // Function to launch a URL fetched from Firebase Remote Config
  Future<void> launchURL() async {
    // Get the instance of FirebaseRemoteConfig
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      // Set configuration settings for fetching remote config
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout:
              const Duration(seconds: 10), // Set fetch timeout to 10 seconds
          minimumFetchInterval:
              Duration.zero, // Set minimum fetch interval to zero (no cache)
        ),
      );

      // Fetch and activate the remote config values
      await remoteConfig.fetchAndActivate();

      // Retrieve the download link from Firebase Remote Config
      final String updateUrl = remoteConfig.getString('download_link');

      // Check if the URL can be launched (e.g., it's a valid URL)
      if (await canLaunch(updateUrl)) {
        // Launch the URL if it's valid
        await launch(updateUrl);
      } else {
        // Show error message if the URL cannot be launched
        _showErrorMessage('Could not launch the provided URL.');
      }
    } catch (e) {
      // Handle errors (e.g., network issues, Firebase fetch errors)
      _showErrorMessage('An error occurred while trying to launch the URL.');
    }
  }

  void _showErrorMessage(String msg) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            title: Center(
              child: Text(
                msg,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: isDark
                    ? const AssetImage('assets/loading_background_dark.png')
                    : const AssetImage('assets/loading_background_light.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: _showCards
                ? const SizedBox()
                : Center(
                    child: isDark
                        ? Image.asset('assets/Loading_gif_dark.gif')
                        : Image.asset('assets/Loading_gif_light.gif')),
          ),
        ),
      ),
    );
  }
}

class Cards extends StatefulWidget {
  const Cards({super.key});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  final controller = PageController();
  int? last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                if (index == 0 && last == 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomePage(),
                    ),
                  );
                }
                last = index;
              });
            },
            children: const [
              OnboardingPage(
                title: 'Track Accidents',
                description: 'Easily track and report accidents in real-time.',
                imageAsset: 'assets/IVision.png',
                color: Colors.red,
              ),
              OnboardingPage(
                title: 'Get Notifications',
                description:
                    'Receive timely notifications about accidents and updates.',
                imageAsset: 'assets/IVision.png',
                color: Colors.yellow,
              ),
              OnboardingPage(
                title: 'Google Maps',
                description: 'Built In Google Maps and its Service.\n',
                imageAsset: 'assets/IVision.png',
                color: Colors.red,
              ),
              OnboardingPage(
                title: 'User-Friendly Interface',
                description:
                    'Enjoy a seamless and user-friendly interface for tracking and reporting.',
                imageAsset: 'assets/IVision.png',
                color: Colors.yellow,
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ),
                    );
                  },
                  child: const Text(
                    'SKIP',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SmoothPageIndicator(
                  controller: controller,
                  count: 4,
                  effect: const ExpandingDotsEffect(),
                ),
                // Optionally, you can add a "Next" button here for better flow
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final Color color;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageAsset),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
