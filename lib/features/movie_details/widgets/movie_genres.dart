import 'package:flutter/material.dart';

class MovieGenres extends StatelessWidget {
  const MovieGenres({super.key});

  final List<String> genres = const [
    'Action',
    'Sci-Fi',
    'Adventure',
    'Fantasy',
    'Horror',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:MainAxisAlignment.start  ,
        children: [
          const Text(
            'Genres',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width:double.infinity  ,
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment:WrapCrossAlignment .start  ,
              spacing: 8,
              runSpacing: 15,
              children: genres.map((genre) {
                return Expanded(
                  child: Container(
                    width: 110,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff343534),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      genre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ) ;
              }).toList(),
            ),
          ) ,
        ],
      ),
    );
  }
}