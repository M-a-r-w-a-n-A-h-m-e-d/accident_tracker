import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../main/navigation_bar.dart';

class ShareApp extends StatefulWidget {
  const ShareApp({super.key});

  @override
  State<ShareApp> createState() => _ShareAppState();
}

class _ShareAppState extends State<ShareApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(myIndex: 2),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/top_background.png',
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: -25,
                    right: 10,
                    child: Image.asset(
                      'assets/car.png',
                      width: 150,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 30,
                    top: 30,
                    child: Image.asset(
                      'assets/image.png',
                      height: 38,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 30,
                    child: IconButton(
                      onPressed: () => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(
                              myIndex: 2,
                            ),
                          ),
                        ),
                      },
                      icon: Image.asset(
                        'assets/go_back.png',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 200,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final remoteConfig = FirebaseRemoteConfig.instance;
                  await remoteConfig.setConfigSettings(
                    RemoteConfigSettings(
                      fetchTimeout: const Duration(seconds: 10),
                      minimumFetchInterval: Duration.zero,
                    ),
                  );
                  await remoteConfig.fetchAndActivate();
                  final String updateUrl =
                      remoteConfig.getString('share_content') +
                          remoteConfig.getString('download_link');
                  await Share.share(updateUrl);
                },
                child: Text(
                  'Share Our App',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
