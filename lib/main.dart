import 'package:accident_tracker/config/routes/theme_provider.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'App/main/loading_page.dart';
import 'core/services/api.dart';
import 'core/usecases/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://e9d129a3baa4efe0d82161925e4e95ca@o4507998596759552.ingest.de.sentry.io/4507998601412688';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then(
        (_) => runApp(
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
            child: const MyApp(),
          ),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ConnectionNotifier(
          connectionNotificationOptions: const ConnectionNotificationOptions(
            alignment: AlignmentDirectional.center,
            width: 170,
            height: 45,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            connectedText: 'Connected',
            disconnectedText: 'Reconnecting...',
          ),
          child: MaterialApp(
            theme: themeProvider.themeData,
            debugShowCheckedModeBanner: false,
            title: 'IVision',
            home: const LoadingPage(),
          ),
        );
      },
    );
  }
}
