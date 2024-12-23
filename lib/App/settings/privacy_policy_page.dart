import 'package:accident_tracker/App/auth/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main/navigation_bar.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String privacy = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadTermsText();
  }

  Future<void> _loadTermsText() async {
    try {
      String fileContents =
          await rootBundle.loadString('assets/privacy_policy.txt');

      setState(() {
        privacy = fileContents;
      });
    } catch (e) {
      setState(() {
        privacy = 'Error loading terms: $e';
      });
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
            builder: (context) => const Home(myIndex: 2),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSecondary),
            onPressed: () {
              if (FirebaseAuth.instance.currentUser != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(
                      myIndex: 2,
                    ),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUp(),
                  ),
                );
              }
            },
          ),
          title: Text('Privacy Policy',style: TextStyle(color: Theme.of(context).colorScheme.primary),),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            privacy,
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
