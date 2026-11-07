import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../../home/widgets/movie_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFF121312),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    TextField(
                      onChanged: (val) => provider.search(val),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: const Color(0xFF282A28),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: provider.isLoading
                          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                          : provider.searchResults.isEmpty
                          ? Center(
                        child: Image.asset(
                          'assets/images/empty.png',
                          width: 110,
                          height: 110,
                          fit: BoxFit.contain,
                        ),
                      )
                          : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: provider.searchResults.length,
                        itemBuilder: (context, index) {
                          return MovieCard(
                            movie: provider.searchResults[index],
                            width: double.infinity,
                            height: double.infinity,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}