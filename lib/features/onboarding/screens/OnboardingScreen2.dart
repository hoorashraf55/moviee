import 'package:flutter/material.dart';

import 'onbordingscreens3.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  static const Color yellow = Color(0xFFFFC61A);
  static const Color dark = Color(0xFF0B0B0F);
  static const Color blue = Color(0xFF084250);

  static const double imageHeightFactor = 0.80;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: blue,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * imageHeightFactor,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/onpording2.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        blue.withOpacity(0.0),
                        blue.withOpacity(0.0),
                        blue.withOpacity(0.6),
                        blue,
                      ],
                      stops: const [0.0, 0.0, 0.85, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 25, 24, 50),
              decoration: const BoxDecoration(
                color: dark,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Discover Movies',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Explore a vast collection of movies in all\n qualities '
                        'and genres. Find your next \nfavorite film with ease.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardingScreen3(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}