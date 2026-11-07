import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/movie_model.dart';
import '../../details/screens/movie_details_screen.dart';
import '../providers/library_provider.dart';

class LibraryMovieCard extends StatelessWidget {
  final Map<String, dynamic> movie;

  const LibraryMovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final movieModel = MovieModel.fromMap(movie);

    final imageUrl = movieModel.mediumCoverImage.isNotEmpty
        ? movieModel.mediumCoverImage
        : movieModel.largeCoverImage;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Movie Poster
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(
                    movie: movieModel,
                  ),
                ),
              );
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xff343534),
                  child: const Icon(
                    Icons.movie,
                    color: Colors.white,
                    size: 35,
                  ),
                );
              },
            ),
          ),

          // Rating
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movieModel.rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 13,
                  ),
                ],
              ),
            ),
          ),

          // Remove Button
          Positioned(
            top: 2,
            left: 2,
            child: Consumer<LibraryProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  onPressed: () {
                    provider.removeFromWatchlist(movieModel.id);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.65),
                  ),
                );
              },
            ),
          ),

          // Movie Title
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              color: Colors.black.withOpacity(0.7),
              child: Text(
                movieModel.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}