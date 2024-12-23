import 'package:accident_tracker/App/auth/forgot_pass_page.dart';
import 'package:accident_tracker/App/auth/sign_up_page.dart';
import 'package:accident_tracker/App/main/welcome_page.dart';
import 'package:accident_tracker/core/services/auth_service.dart';
import 'package:accident_tracker/common/Widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common/Widgets/passText_customWidget.dart';
import '../main/navigation_bar.dart';
import 'verify_email_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  bool canPop = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showErrorMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              msg,
              style: const TextStyle(color: Color(0xFFFFFFFF)),
            ),
          ),
        );
      },
    );
  }

  Future<void> _signUserIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorMessage('Please fill all fields');
      return;
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const Home(
                      myIndex: 1,
                    ),),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const VerifyEmailPage()),
          );
        }
      } else {
        _showErrorMessage('User does not exist');
      }
    } catch (e) {
      _showErrorMessage('Error signing in');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 50),
                MyTextField(
                  controller: emailController,
                  label: 'Email Address',
                  obscureText: false,
                  prefixIcon: const Icon(Icons.mail_outlined),
                ),
                const SizedBox(height: 25),
                PassTextField(
                  controller: passwordController,
                  label: 'Password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 17),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPass(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 153, 0, 255),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _signUserIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 110, vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Sign In',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                Text(
                  '- or sign in with -',
                  style: TextStyle(
                      fontSize: 19,
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        AuthService().signInWithGoogle();
                      },
                      icon: Image.asset(
                        'assets/google.png',
                        height: 80,
                        width: 80,
                      ),
                    ),
                    IconButton(
                      onPressed: () => AuthService.signInWithFacebook(),
                      icon: Image.asset(
                        'assets/facebook.png',
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New user?',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      child: Text(
                        'Create an account',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    DateTime currentTime = DateTime.now();
    final difference = currentTime.difference(lastBackPressed);
    bool isExitWarning = difference >= const Duration(seconds: 2);

    lastBackPressed = currentTime;

    if (isExitWarning) {
      Fluttertoast.showToast(
        msg: 'Press back again to exit',
        fontSize: 18,
      );
      return Future.value(false);
    } else {
      Fluttertoast.cancel();
      return Future.value(true);
    }
  }

  DateTime lastBackPressed = DateTime.now();
}
