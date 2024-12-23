import 'dart:io';
import 'package:accident_tracker/App/auth/auth_page.dart';
import 'package:accident_tracker/App/auth/sign_up_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool canPop = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (bool value) async {
        exit(0);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
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
                  right: 30,
                  top: 30,
                  child: Image.asset(
                    'assets/image.png',
                    height: 38,
                  ),
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
              ],
            ),
            const SizedBox(height: 35),
            const FadeTransition(
              opacity: kAlwaysCompleteAnimation,
              child: Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 47,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 45),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Sign In',
                style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUp(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            Image.asset(
              'assets/IVision.png',
              height: 300,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
