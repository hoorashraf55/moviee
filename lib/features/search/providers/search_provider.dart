import 'package:flutter/material.dart';
import '../../../core/api/api_manager.dart';
import '../../../core/models/movie_model.dart';

class SearchProvider extends ChangeNotifier {
  List<MovieModel> searchResults = [];
  bool isLoading = false;
  String query = '';

  Future<void> search(String text) async {
    query = text;
    if (text.trim().isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      searchResults = await ApiManager.searchMovies(text);
    } catch (e) {
      debugPrint('Search Error: $e');
      searchResults = [];
    }

    isLoading = false;
    notifyListeners();
  }
}