import 'package:accident_tracker/App/auth/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main/navigation_bar.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  bool canResendEmail = true;

  void update() async {
    try {
      if (canResendEmail) {
        setState(() {
          canResendEmail = false;
        });
        await FirebaseAuth.instance.sendPasswordResetEmail(
            email: FirebaseAuth.instance.currentUser!.email.toString());
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            backgroundColor: Color.fromARGB(255, 41, 221, 86),
            title: Center(
              child: Text(
                'Password Reset Email Sent',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
        Future.delayed(const Duration(seconds: 1)).then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthPage(),
            ),
          ),
        );
      }
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(myIndex: 0),
          ),
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthPage(),
                        ),
                      );
                    },
                    icon: Image.asset(
                      'assets/go_back.png',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 55),
            Text(
              'Update Your Password?',
              style: TextStyle(color:Theme.of(context).colorScheme.onSecondary, fontSize: 28),
            ),
            const SizedBox(height: 25),
            Center(
              child: Text(
                'A reset password link has been sent to your email.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 17),
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: update,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Resend',
                style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
