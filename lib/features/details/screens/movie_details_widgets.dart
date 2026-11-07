import 'package:flutter/material.dart';
import '../../../core/api/api_manager.dart';
import '../../../core/models/movie_model.dart';
import '../../home/widgets/movie_card.dart';
import 'package:provider/provider.dart';
import '../../library/providers/library_provider.dart';

// 1. Header Cover & Actions
class MovieDetailsHeader extends StatelessWidget {
  final MovieModel movie;
  final double screenHeight;

  const MovieDetailsHeader({
    super.key,
    required this.movie,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          movie.largeCoverImage.isNotEmpty
              ? movie.largeCoverImage
              : movie.mediumCoverImage,
          width: double.infinity,
          height: screenHeight * 0.52,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: screenHeight * 0.52,
            color: Colors.grey[900],
            child: const Icon(Icons.movie, size: 80, color: Colors.amber),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(140),
                  Colors.transparent,
                  const Color(0xFF121312),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: 48,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          top: 48,
          right: 16,
          child: Consumer<LibraryProvider>(
            builder: (context, libraryProvider, child) {
              final isSaved = libraryProvider.isInWatchlist(movie.id);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(45),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    if (isSaved) {
                      libraryProvider.removeFromWatchlist(movie.id);
                    } else {
                      libraryProvider.addToWatchlist(movie.toMap());
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isSaved
                              ? 'Removed from Watchlist'
                              : 'Added to Watchlist',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.amber : Colors.white,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 2. Stats Row Widget
class MovieStatsRow extends StatelessWidget {
  final MovieModel movie;

  const MovieStatsRow({super.key, required this.movie});

  Widget _buildStatChip(IconData icon, Color iconColor, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF282A28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatChip(
            Icons.favorite,
            const Color(0xFFFFC107),
            '${movie.likeCount > 0 ? movie.likeCount : 15}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatChip(
            Icons.access_time_filled,
            const Color(0xFFFFC107),
            '${movie.runtime > 0 ? movie.runtime : 90}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatChip(
            Icons.star,
            const Color(0xFFFFC107),
            '${movie.rating}',
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// 4. Similar Movies Section
class SimilarMoviesSection extends StatelessWidget {
  final MovieModel movie;

  const SimilarMoviesSection({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MovieModel>>(
      future: ApiManager.getMovies(
        genre: movie.genres.isNotEmpty ? movie.genres.first : 'Action',
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: Colors.amber),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        final similarMovies =
        snapshot.data!.where((m) => m.id != movie.id).take(4).toList();

        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: similarMovies.length,
          itemBuilder: (context, index) {
            return MovieCard(
              movie: similarMovies[index],
              width: double.infinity,
              height: double.infinity,
            );
          },
        );
      },
    );
  }
}

// 5. Cast Tile Widget
class CastTile extends StatelessWidget {
  final String actorName;
  final String characterName;
  final String imageUrl;

  const CastTile({
    super.key,
    required this.actorName,
    required this.characterName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF282A28),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              width: 54,
              height: 54,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _placeholder();
              },
            )
                : _placeholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name : $actorName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Character : $characterName',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 54,
      height: 54,
      color: Colors.grey[800],
      child: const Icon(
        Icons.person,
        color: Colors.amber,
        size: 28,
      ),
    );
  }
}

