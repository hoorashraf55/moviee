import 'package:flutter/material.dart';
import '../../../core/api/api_manager.dart';
import '../../../core/models/movie_model.dart';

class HomeProvider extends ChangeNotifier {
  List<MovieModel> availableNowMovies = [];
  List<MovieModel> actionMovies = [];

  bool isLoading = true;
  String? errorMessage;

  HomeProvider() {
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        ApiManager.getMovies(limit: 5, sortBy: 'year'),
        ApiManager.getMovies(limit: 10, genre: 'Action'),
      ]);

      availableNowMovies = results[0];
      actionMovies = results[1];

      if (availableNowMovies.isEmpty && actionMovies.isEmpty) {
        errorMessage = 'No movies available right now.';
      }
    } catch (e) {
      errorMessage = 'Unable to load movies. Please try again.';
      debugPrint('HomeProvider Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}