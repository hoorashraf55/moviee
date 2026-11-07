import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api_manager.dart';
import '../../../core/models/movie_model.dart';
import '../../library/providers/library_provider.dart';
import 'movie_details_widgets.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<MovieModel> movieDetailsFuture;

  @override
  void initState() {
    super.initState();
    movieDetailsFuture = ApiManager.getMovieDetails(widget.movie.id);
  }

  List<Widget> _buildScreenshotsList(MovieModel movie) {
    final screenshots = [
      movie.screenshot1,
      movie.screenshot2,
      movie.screenshot3,
    ].whereType<String>().where((url) => url.isNotEmpty).toList();

    if (screenshots.isEmpty) {
      screenshots.add(
        movie.largeCoverImage.isNotEmpty
            ? movie.largeCoverImage
            : movie.mediumCoverImage,
      );
    }

    return screenshots.map((imageUrl) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 160,
                color: Colors.grey[900],
                child: const Icon(Icons.movie, color: Colors.amber, size: 40),
              );
            },
          ),
        ),
      );
    }).toList();
  }

  Widget _buildDetails(MovieModel movie) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovieDetailsHeader(movie: movie, screenHeight: screenHeight),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    movie.year.toString(),
                    style: TextStyle(color: Colors.grey[400], fontSize: 15),
                  ),
                ),
                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      await context.read<LibraryProvider>().addToHistory(
                        movie.toMap(),
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to History'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Watch',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                MovieStatsRow(movie: movie),
                const SizedBox(height: 24),
                const SectionTitle(title: 'Screen Shots'),
                const SizedBox(height: 12),
                ..._buildScreenshotsList(movie),

                const SizedBox(height: 14),
                const SectionTitle(title: 'Similar'),
                const SizedBox(height: 6),
                SimilarMoviesSection(movie: movie),

                const SizedBox(height: 24),
                const SectionTitle(title: 'Summary'),
                const SizedBox(height: 10),
                Text(
                  movie.summary.isNotEmpty
                      ? movie.summary
                      : 'No summary available.',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 20,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),
                const SectionTitle(title: 'Cast'),
                const SizedBox(height: 12),

                if (movie.cast.isEmpty)
                  Text(
                    'Cast information is not available.',
                    style: TextStyle(color: Colors.grey[400]),
                  )
                else
                  ...movie.cast.map(
                    (actor) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CastTile(
                        actorName: actor.name,
                        characterName: actor.characterName,
                        imageUrl: actor.imageUrl,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
                const SectionTitle(title: 'Genres'),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: movie.genres.map((genre) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF282A28),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        genre,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 35),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: FutureBuilder<MovieModel>(
        future: movieDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Unable to load movie details.',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        movieDetailsFuture = ApiManager.getMovieDetails(
                          widget.movie.id,
                        );
                      });
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return _buildDetails(snapshot.data!);
        },
      ),
    );
  }
}
