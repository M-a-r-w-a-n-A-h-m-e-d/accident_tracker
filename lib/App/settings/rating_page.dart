import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';

import '../main/navigation_bar.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating = 0;

  @override
  void initState() {
    super.initState();
  }



  void sendRating() {
    if (_rating > 0) {
      // Handle rating submission logic
      print('Rating sent: $_rating');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you for your rating of $_rating!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating before sending.'),
        ),
      );
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
              const SizedBox(height: 100),
              Text(
                'Rating: $_rating',
                style: TextStyle(
      fontSize: 24.0,
      color: Theme.of(context).colorScheme.onSecondary,
    ),
              ),
              AnimatedRatingStars(
                onChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
                displayRatingValue: true,
                interactiveTooltips: true,
                customFilledIcon: Icons.star,
                customHalfFilledIcon: Icons.star_half,
                customEmptyIcon: Icons.star_border,
                starSize: 40.0,
                animationDuration: const Duration(milliseconds: 500),
                animationCurve: Curves.easeInOut,
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: sendRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Send Rating',
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
