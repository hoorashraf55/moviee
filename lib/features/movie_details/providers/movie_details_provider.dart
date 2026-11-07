import 'package:flutter/material.dart';

class MovieDetailsProvider extends ChangeNotifier {
  bool isLoading = false;

  Map<String, dynamic>? movie;

  String? errorMessage;

  void setMovie(Map<String, dynamic> movieData) {
    movie = movieData;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setError(String? error) {
    errorMessage = error;
    notifyListeners();
  }
}