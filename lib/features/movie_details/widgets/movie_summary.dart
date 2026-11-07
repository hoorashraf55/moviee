import 'package:flutter/material.dart';

class MovieSummary extends StatelessWidget {
  const MovieSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Doctor Strange teams up with a mysterious teenage '
                'girl from his dreams who can travel across multiverses, '
                'to battle multiple threats, including other-universe '
                'versions of himself.',
            style: TextStyle(
              color: Colors.white ,
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w400 ,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}