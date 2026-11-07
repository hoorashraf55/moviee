import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class ApiManager {
  static const String baseUrl = 'https://movies-api.accel.li/api/v2';

  // Get movies for Home, Search and other sections
  static Future<List<MovieModel>> getMovies({
    int limit = 20,
    int page = 1,
    String? genre,
    String? queryTerm,
    String sortBy = 'date_added',
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
      'page': page.toString(),
      'sort_by': sortBy,
    };

    if (genre != null && genre.isNotEmpty) {
      queryParams['genre'] = genre;
    }

    if (queryTerm != null && queryTerm.isNotEmpty) {
      queryParams['query_term'] = queryTerm;
    }

    final url = Uri.parse('$baseUrl/list_movies.json')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception(
          'Movies API failed: ${response.statusCode}',
        );
      }

      final decodedData = jsonDecode(response.body);

      if (decodedData is! Map<String, dynamic>) {
        throw const FormatException('Invalid API response.');
      }

      final data = decodedData['data'];

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Movies data is missing.');
      }

      final moviesJson = data['movies'];

      if (moviesJson is! List) {
        throw const FormatException('Movies list is missing.');
      }

      return moviesJson
          .whereType<Map<String, dynamic>>()
          .map((json) => MovieModel.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('Get Movies Error: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  // Get full details of one movie
  static Future<MovieModel> getMovieDetails(int movieId) async {
    final url = Uri.parse('$baseUrl/movie_details.json').replace(
      queryParameters: {
        'movie_id': movieId.toString(),
        'with_images': 'true',
        'with_cast': 'true',
      },
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception(
          'Movie details API failed: ${response.statusCode}',
        );
      }

      final decodedData = jsonDecode(response.body);

      if (decodedData is! Map<String, dynamic>) {
        throw const FormatException('Invalid movie details response.');
      }

      final data = decodedData['data'];

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Movie details data is missing.');
      }

      final movieJson = data['movie'];

      if (movieJson is! Map<String, dynamic>) {
        throw const FormatException('Movie details are missing.');
      }

      return MovieModel.fromJson(movieJson);
    } catch (e, stackTrace) {
      debugPrint('Get Movie Details Error: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  static Future<List<MovieModel>> searchMovies(String query) {
    return getMovies(queryTerm: query);
  }
}