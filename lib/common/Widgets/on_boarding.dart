import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final Color color;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imageAsset,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
