import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main/navigation_bar.dart';

class MyFeedback extends StatefulWidget {
  const MyFeedback({super.key});

  @override
  State<MyFeedback> createState() => _MyFeedbackState();
}

class _MyFeedbackState extends State<MyFeedback> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(
              myIndex: 2,
            ),
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
                          builder: (context) => const Home(
                            myIndex: 2,
                          ),
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
            const SizedBox(height: 50),
            Text(
              'put ur feedback here',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  labelText: 'Your Feedback',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                maxLines: 4,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Submit Feedback',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom:15.0),
              child: ElevatedButton(
                onPressed: _launchEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Contact Us',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Future<void> _submitFeedback() async {
    String feedback = _feedbackController.text;
    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter feedback.')),
      );
      return;
    }
    try {
      final email = FirebaseAuth.instance.currentUser?.email ?? 'unknown';
      final name = FirebaseAuth.instance.currentUser?.displayName ?? 'unknown';
      SentryId sentryId =
          await Sentry.captureMessage("User feedback submitted");
      final userFeedback = SentryUserFeedback(
        name: name,
        eventId: sentryId,
        email: email,
        comments: feedback,
      );
      await Sentry.captureUserFeedback(userFeedback);
      print('Feedback submitted: $feedback');
      _feedbackController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );
    } catch (e) {
      print('Failed to submit feedback: $e');
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'marwanahmedabdelrahim.feedback@gmail.com',
      query: Uri.encodeFull('subject=Feedback for MyApp'),
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      throw 'Could not launch $emailLaunchUri';
    }
  }
}
