import 'dart:async';
import 'package:accident_tracker/App/main/loading_page.dart';
import 'package:accident_tracker/App/auth/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final user = FirebaseAuth.instance.currentUser;
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = true;

  Future sendVerificationEmail() async {
    try {
      if (canResendEmail) {
        setState(() {
          canResendEmail = false;
        });
        final user = FirebaseAuth.instance.currentUser!;
        await user.sendEmailVerification();
      }
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const LoadingPage()
      : PopScope(
          canPop: false,
          onPopInvoked: (bool value) async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUp(),
              ),
            );
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: Column(
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
                      top: 30,
                      left: 30,
                      child: IconButton(
                        onPressed: () => {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
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
                const SizedBox(height: 25),
                const Text(
                  'Check Your Email',
                  style: TextStyle(
                      fontSize: 35,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  'A verification email has been sent to ${user!.email ?? 'Not available'}',
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 121, 35, 202)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: sendVerificationEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(225, 119, 49, 185),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 110, vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Resend Email',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
}
