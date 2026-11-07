import 'package:flutter/material.dart';
import '../../library/screens/watchlist_screen.dart';
import '../widgets/movie_poster.dart';
import '../widgets/movie_info.dart';
import '../widgets/movie_stats.dart';
import '../widgets/movie_screenshots.dart';
import '../widgets/similar_movies.dart';
import '../widgets/movie_summary.dart';
import '../widgets/movie_cast.dart';
import '../widgets/movie_genres.dart';
import 'package:provider/provider.dart';
import '../providers/movie_details_provider.dart';
class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieDetailsProvider>();
    return Scaffold(
      backgroundColor: const Color(0xff121312),
      body:
      provider.isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xffE94545),
        ),
      )
          : provider.errorMessage != null
          ? Center(
        child: Text(
          provider.errorMessage!,
          style: const TextStyle(color: Colors.white),
        ),
      )
          : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              MoviePoster(),
              MovieInfo(),
              SizedBox(height: 8),
              MovieStats(),
              SizedBox(height: 20),
              MovieScreenshots(),
              SizedBox(height: 20),
              SimilarMovies(),
              SizedBox(height: 20),
              MovieSummary(),
              SizedBox(height: 20),
              MovieCast(),
              SizedBox(height: 20),
              MovieGenres(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffE94545),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WatchlistScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.bookmark,
          color: Colors.white,
        ),
      ),
    );
  }
}