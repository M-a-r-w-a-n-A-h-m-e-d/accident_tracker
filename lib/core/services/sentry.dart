import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackHome extends StatelessWidget {
  const FeedbackHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await aMethodThatMightFail();
                } catch (exception, stackTrace) {
                  await Sentry.captureException(exception,
                      stackTrace: stackTrace);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('An error occurred!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 229, 255, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Trigger Error',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackForm()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 229, 255, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Give Feedback',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> aMethodThatMightFail() async {
    throw Exception('This is a test exception');
  }
}

class FeedbackForm extends StatelessWidget {
  final TextEditingController _feedbackController = TextEditingController();

  FeedbackForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Your Feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String feedback = _feedbackController.text;
                if (feedback.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter feedback.')),
                  );
                  return;
                }
                try {
                  final email =
                      FirebaseAuth.instance.currentUser?.email ?? 'unknown';
                  SentryId sentryId =
                      await Sentry.captureMessage("User feedback submitted");
                  final userFeedback = SentryUserFeedback(
                    eventId: sentryId,
                    email: email,
                    comments: feedback,
                  );
                  await Sentry.captureUserFeedback(userFeedback);
                  print('Feedback submitted: $feedback');
                  _feedbackController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Thank you for your feedback!')),
                  );
                } catch (e) {
                  print('Failed to submit feedback: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 212, 0, 255),
                padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Submit Feedback',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _launchEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 195, 0, 255),
                padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Contact Us',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
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
