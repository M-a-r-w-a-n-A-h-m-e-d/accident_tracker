import 'dart:developer';

import 'package:accident_tracker/App/auth/sign_in_page.dart';
import 'package:accident_tracker/App/auth/verify_email_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/database.dart';
import '../main/navigation_bar.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            // var result =
            //     DataBase(email: user!.email ?? '', password: 'password')
            //         .searchWithEmail(user.email ?? '');

            if (snapshot.hasData) {
              var user = snapshot.data;
              if (user != null &&
                  user.providerData.any((provider) =>
                      provider.providerId == 'google.com' ||
                      provider.providerId == 'facebook.com' ||
                      provider.providerId == 'apple.com')) {
                return const Home(myIndex: 1);
              }
              if (user != null && user.emailVerified) {
                return const Home(myIndex: 1);
              } else if (user != null && !(user.emailVerified)) {
                return const VerifyEmailPage();
              }
            }
          }
          return const SignIn();
        },
      ),
    );
  }
}
