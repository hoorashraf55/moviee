import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/library_provider.dart';
import '../widgets/library_movie_card.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = context.watch<LibraryProvider>().watchlist;

    return Scaffold(
      backgroundColor: const Color(0xff121312),
      appBar: AppBar(
        backgroundColor: const Color(0xff121312),
        title: const Text(
          'Watchlist',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: movies.isEmpty
          ? const Center(
        child: Text(
          'No movies in watchlist yet',
          style: TextStyle(color: Colors.white),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: movies.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          childAspectRatio: 2 / 3,
        ),
        itemBuilder: (context, index) {
          return LibraryMovieCard(
            movie: movies[index],
          );
        },
      ),
    );
  }
}