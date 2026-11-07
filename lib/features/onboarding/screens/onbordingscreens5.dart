import 'package:flutter/material.dart';

import '../onbordingscreens6.dart';


class OnboardingScreen5 extends StatelessWidget {
  const OnboardingScreen5({super.key});

  static const Color dark = Color(0xFF121312);
  static const Color yellow = Color(0xFFFFBB3B);
  static const Color wine = Color(0xFF601321);

  static const double imageHeightFactor = 0.80;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: wine,
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
                  "assets/images/onbording5.jpg",
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),

                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00601321),
                        Color(0x00601321),
                        Color(0x99601321),
                        Color(0xFF601321),
                      ],
                      stops: [0.0, 0.0, 0.85, 1.0],
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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 25),
              decoration: const BoxDecoration(
                color: dark,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Rate, Review, and Learn",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Share your thoughts on the movies\n you've watched. Dive deep into film \ndetails and help others discover great\n movies with your reviews.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // زر Next
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const OnboardingScreen6(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellow,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // زر Back
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: yellow,
                          side: const BorderSide(color: yellow, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}