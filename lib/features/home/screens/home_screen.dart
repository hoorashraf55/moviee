import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/features/home/providers/home_provider.dart';
import 'package:movies_app/features/home/widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.62);

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFF121312),
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              );
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.movie_filter_outlined,
                        color: Colors.amber,
                        size: 55,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        provider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: provider.fetchHomeData,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final availableMovies = provider.availableNowMovies;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/background.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF121312).withOpacity(0.80),
                                const Color(0xFF121312).withOpacity(0.60),
                                const Color(0xFF121312),
                              ],
                              stops: const [0.0, 0.55, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 45),

                          Image.asset(
                            'assets/images/available_now.png',
                            height: 90,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(height: 10),
                          SizedBox(
                            height: 350,
                            child: availableMovies.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No movies available',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : PageView.builder(
                                    controller: _pageController,
                                    itemCount: availableMovies.length,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    },
                                    itemBuilder: (context, index) {
                                      double scale = index == _currentPage
                                          ? 1.0
                                          : 0.84;

                                      return Transform.scale(
                                        scale: scale,
                                        child: MovieCard(
                                          movie: availableMovies[index],
                                          width: 220,
                                          height: 340,
                                        ),
                                      );
                                    },
                                  ),
                          ),

                          const SizedBox(height: 10),

                          Image.asset(
                            'assets/images/watch_now.png',
                            height: 95,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(height: 15),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Action',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Row(
                            children: [
                              Text(
                                'See More',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 3),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.amber,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 180,
                    child: provider.actionMovies.isEmpty
                        ? const Center(
                            child: Text(
                              'No Action movies available',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: provider.actionMovies.length,
                            itemBuilder: (context, index) {
                              return MovieCard(
                                movie: provider.actionMovies[index],
                                width: 120,
                                height: 180,
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
