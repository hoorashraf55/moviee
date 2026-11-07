import 'package:flutter/material.dart';
import '../../../core/api/api_manager.dart';
import '../../../core/models/movie_model.dart';
import '../../home/widgets/movie_card.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final List<String> genres = [
    'Action',
    'Adventure',
    'Animation',
    'Biography',
    'Comedy',
    'Crime',
    'Drama',
  ];

  String selectedGenre = 'Action';
  List<MovieModel> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiManager.getMovies(genre: selectedGenre);
      setState(() {
        movies = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  final genre = genres[index];
                  final isSelected = genre == selectedGenre;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ChoiceChip(
                      showCheckmark: false,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      label: Text(
                        genre,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.amber,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                          color: Colors.amber,
                          width: 1.5,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected && selectedGenre != genre) {
                          setState(() {
                            selectedGenre = genre;
                          });
                          _fetchMovies();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                  : movies.isEmpty
                  ? const Center(
                child: Text(
                  'No movies found in this genre',
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return MovieCard(
                    movie: movies[index],
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}