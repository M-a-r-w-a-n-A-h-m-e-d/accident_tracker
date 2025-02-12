import 'package:accident_tracker/App/main/loading_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'flavors.dart';

class App extends StatelessWidget {

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: F.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _flavorBanner(
        child: const LoadingPage(),
        show: kDebugMode,
      ),
    );
  }

  Widget _flavorBanner({
    required Widget child,
    bool show = true,
  }) =>
      show
          ? Banner(
        location: BannerLocation.topStart,
        message: F.name,
        color: Colors.green.withOpacity(0.6),
        textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            letterSpacing: 1.0),
        textDirection: TextDirection.ltr,
        child: child,
      )
          : Container(
        child: child,
      );
}
