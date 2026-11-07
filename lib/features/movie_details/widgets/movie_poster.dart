import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../library/providers/library_provider.dart';

class MoviePoster extends StatelessWidget {
  const MoviePoster({super.key});

  @override
  Widget build(BuildContext context) {
    final libraryProvider = context.watch<LibraryProvider>();

    // بيانات مؤقتة للفيلم الحالي
    final movie = {
      'id': 1,
      'image':
      'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
      'rating': '7.6',
    };

    final isSaved = libraryProvider.isInWatchlist(movie['id']);

    return Stack(
      children: [
        Image.network(
          movie['image'] as String,
          height: 450,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        Positioned(
          top: 15,
          left: 15,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),

        Positioned(
          top: 15,
          right: 15,
          child: IconButton(
            onPressed: () {
              if (isSaved) {
                libraryProvider.removeFromWatchlist(movie['id']);
              } else {
                libraryProvider.addToWatchlist(movie);
              }
            },
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),

        const Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Icon(
            Icons.play_circle_fill,
            color: Colors.yellow ,
            size: 65,
          ),
        ),
      ],
    );
  }
}