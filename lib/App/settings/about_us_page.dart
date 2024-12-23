import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main/navigation_bar.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  @override
  void initState() {
    super.initState();
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSecondary),
            onPressed: () {
              if (FirebaseAuth.instance.currentUser != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(myIndex: 2),
                  ),
                );
              }
            },
          ),
          centerTitle: true,
          title: Text(
            'About Us',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(left: 13, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Text(
                    'We are a group of programmers consisting of 8 people committed to an educational body (Misr International Academy). Therefore, we were assigned a graduation project consisting of integrated systems and artificial intelligence.',
                    style: TextStyle(
      fontSize: 20.0,
      color: Theme.of(context).colorScheme.onSecondary,
    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Our Team',
                    style: TextStyle(
      fontSize: 20.0,
      color: Theme.of(context).colorScheme.onSecondary,
    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Our mission is to develop reliable and efficient solutions that can quickly identify and respond to accidents, ultimately saving lives and reducing the impact of road incidents.',
                    style: TextStyle(
      fontSize: 20.0,
      color: Theme.of(context).colorScheme.onSecondary,
    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Why Choose Us?',
                    style: TextStyle(
      fontSize: 20.0,
      color: Theme.of(context).colorScheme.onSecondary,
    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Expertise: With backgrounds in software development, machine learning, and automotive engineering, our team is equipped to tackle the complexities of accident detection.',
                    style: TextStyle(
      fontSize: 20.0,
      color: Theme.of(context).colorScheme.onSecondary,
    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Innovation: We continuously strive to stay ahead of the curve, integrating the latest technologies to improve our systems.',
                    style: TextStyle(
      fontSize: 20.0,
      color: Theme.of(context).colorScheme.onSecondary,
    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Commitment: Our dedication to safety drives us to provide solutions that make a difference in real-world scenarios.',
                    style: TextStyle(
      fontSize: 20.0,
      color: Theme.of(context).colorScheme.onSecondary,
    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
