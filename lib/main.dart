import 'package:accident_tracker/App/home/home_page.dart';
import 'package:accident_tracker/App/main/navigation_bar.dart';
import 'package:accident_tracker/config/routes/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'App/auth/auth_page.dart';
import 'App/settings/language_page.dart';
import 'config/routes/language_provider.dart';
import 'core/services/database.dart';
import 'core/usecases/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'App/main/loading_page.dart';
import 'generated/l10n.dart';
import 'dart:async';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://e9d129a3baa4efe0d82161925e4e95ca@o4507998596759552.ingest.de.sentry.io/4507998601412688';
      options.profilesSampleRate = 1.0;
      options.tracesSampleRate = 1.0;
    },
    appRunner: () {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then(
        (_) => runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) => ThemeProvider(),
              ),
              ChangeNotifierProvider<LanguageProvider>(
                create: (_) => LanguageProvider(),
              ),
            ],
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
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
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
            locale:
                languageProvider.loaded ? languageProvider.currentLocale : null,
            localizationsDelegates: const [
              S.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            title: 'IVision',
            home: const LoadingPage(),
          ),
        );
      },
    );
  }
}
