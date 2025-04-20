import 'package:accident_tracker/App/auth/auth_page.dart';
import 'package:accident_tracker/App/auth/sign_in_page.dart';
import 'package:accident_tracker/common/Widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final emailController = TextEditingController();
  bool canResendEmail = true;

  @override
  void initState() {
    super.initState();
  }


  void forgotPass() async {
    if (emailController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              'Please enter your email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    } else {
      try {
        setState(() {
          canResendEmail = false;
        });

        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);

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

        await Future.delayed(const Duration(seconds: 5));
        setState(() {
          canResendEmail = true;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthPage(),
          ),
        );
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignIn(),
          ),
        );
        return false;
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
                          builder: (context) => const AuthPage(),
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
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Please enter your email to reset password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromARGB(255, 148, 42, 219),
                          fontSize: 17),
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: emailController,
                      obscureText: false,
                      prefixIcon: const Icon(Icons.mail_outlined),
                      label: "Email Address",
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: forgotPass,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(225, 119, 49, 185),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 110, vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'RESET',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
