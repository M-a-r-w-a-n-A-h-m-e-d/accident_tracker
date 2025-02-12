import 'package:accident_tracker/App/auth/auth_page.dart';
import 'package:accident_tracker/App/settings/privacy_policy_page.dart';
import 'package:accident_tracker/App/auth/sign_in_page.dart';
import 'package:accident_tracker/App/settings/terms_page.dart';
import 'package:accident_tracker/common/Widgets/my_textfield.dart';
import 'package:accident_tracker/core/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../common/Widgets/passText_customWidget.dart';
import '../../core/services/auth_service.dart';
import '../main/navigation_bar.dart';
import 'verify_email_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool accept = false;
  bool agreement = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUserUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorDialog('Please fill all fields');
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    if (!agreement) {
      _showErrorDialog('You have to agree on our privacy policy & Terms');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
        DataBase(name: name,email: email,password: password).connection();
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
      }
      if (user != null && user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home(myIndex: 1)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VerifyEmailPage()),
        );
      }
    } catch (e) {
      _showErrorDialog('Sign Up Failed');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignIn(),
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
                const SizedBox(height: 33),
                MyTextField(
                  controller: nameController,
                  label: 'Name',
                  obscureText: false,
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 25),
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
                const SizedBox(height: 25),
                PassTextField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: accept,
                      onChanged: (value) => {
                        setState(() {
                          accept = !accept;
                          value = accept;
                          agreement = value!;
                        })
                      },
                    ),
                    Text(
                      'agree on our',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Terms(),
                          ),
                        );
                      },
                      child: const Text('Terms & Conditions',
                          style: TextStyle(color: Colors.purple)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicy(),
                          ),
                        );
                      },
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: signUserUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 110, vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '- or sign up with -',
                  style: TextStyle(
                      fontSize: 19,
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        var google = await AuthService().signInWithGoogle();
                        if (google != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthPage(),
                            ),
                          );
                        }
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
                      'Have an account?',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign in',
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
}
