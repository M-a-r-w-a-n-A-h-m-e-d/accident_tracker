import 'dart:async';
import 'package:accident_tracker/App/main/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import '../auth/auth_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final shorebirdCodePush = ShorebirdCodePush();
  bool _showCards = false;
  bool isDark = false;
  bool _initialized = false;
  bool _isFirstLaunch = true;
  bool _haveUpgrade = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkFirstLaunch();
    // _initializeShorebird();
  }

  // Future<void> _initializeShorebird() async {
  //   await shorebirdCodePush.currentPatchNumber();
  //   await _checkFirstLaunch();
  // }

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
      print('Initialization error: $e');
    }
  }

  Future<void> _permissionsHandler() async {
    final status = await Permission.location.request();
    final status1 = await Permission.camera.request();
    if (!status.isGranted || !status1.isGranted) {
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

      final latestVersion = remoteConfig.getString('latest_version');
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      if (mounted) {
        setState(() {
          _haveUpgrade = currentVersion != latestVersion;
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

  // Future<void> _shoreBirdCheckForUpdates() async {
  //   try {
  //     await shorebirdCodePush.downloadUpdateIfAvailable();
  //     final isUpdateAvailable =
  //         await shorebirdCodePush.isNewPatchAvailableForDownload();
  //     print(isUpdateAvailable);

  //     if (isUpdateAvailable) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('New update available! Downloading...')),
  //       );

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Update downloaded successfully!')),
  //       );
  //       _shorebirdNavigateToNextPage(true);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('No updates available.')),
  //       );
  //       _shorebirdNavigateToNextPage(false);
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error checking for updates: $e')),
  //     );
  //   }
  // }
  //
  // void _shorebirdNavigateToNextPage(bool x) {
  //   if (x) {
  //     Future.delayed(const Duration(seconds: 3)).then(
  //       (_) => Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const AuthPage(),
  //         ),
  //       ),
  //     );
  //   }
  //   setState(() {
  //     _showCards = _isFirstLaunch;
  //     _initialized = true;
  //   });
  //   if (_haveUpgrade) {
  //     Navigator.of(context, rootNavigator: true).pop();
  //   }
  //   Future.delayed(const Duration(seconds: 3)).then(
  //     (_) => Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => _showCards ? const Cards() : const AuthPage(),
  //       ),
  //     ),
  //   );
  // }

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

  Future<void> launchURL() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await remoteConfig.fetchAndActivate();

      final String updateUrl = remoteConfig.getString('download_link');

      if (await canLaunch(updateUrl)) {
        await launch(updateUrl);
      } else {
        _showErrorMessage('Could not launch the provided URL.');
      }
    } catch (e) {
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
  final controller = LiquidController();
  bool nextScreen = false;
  bool notFirstpage = false;
  int? last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          LiquidSwipe(
            liquidController: controller,
            enableSideReveal: true,
            onPageChangeCallback: (index) {
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
            slideIconWidget: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            pages: const [
              OnboardingPage(
                title: 'Track Accidents',
                description: 'Easily track and report accidents in real-time.',
                imageAsset: 'assets/IVision.png',
                color: Colors.blue,
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
                color: Colors.green,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 16,
            right: 32,
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
                  child: const Text('SKIP'),
                ),
                AnimatedSmoothIndicator(
                  activeIndex: controller.currentPage,
                  count: 4,
                  onDotClicked: (index) {
                    controller.jumpToPage(page: index);
                  },
                  effect: const WormEffect(
                    spacing: 16,
                    dotColor: Colors.white54,
                    activeDotColor: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final page = controller.currentPage + 1;
                    if (page == 4) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomePage(),
                        ),
                      );
                    } else {
                      controller.animateToPage(page: page % 4, duration: 400);
                    }
                  },
                  child: controller.currentPage == 3
                      ? const Text('Get Started')
                      : const Text('NEXT'),
                ),
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
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imageAsset,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
