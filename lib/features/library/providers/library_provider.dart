import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LibraryProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> watchlist = [];
  final List<Map<String, dynamic>> history = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's document
  DocumentReference<Map<String, dynamic>>? get _userDocument {
    final user = _auth.currentUser;

    if (user == null) return null;

    return _firestore.collection('users').doc(user.uid);
  }

  // Load Watchlist and History from Firebase
  Future<void> loadLibrary() async {
    final userDocument = _userDocument;

    if (userDocument == null) return;

    try {
      final watchlistSnapshot =
      await userDocument.collection('watchlist').get();

      final historySnapshot =
      await userDocument.collection('history').get();

      watchlist.clear();
      history.clear();

      for (var doc in watchlistSnapshot.docs) {
        watchlist.add({
          ...doc.data(),
          'id': doc.data()['id'] ?? int.tryParse(doc.id) ?? doc.id,
        });
      }

      for (var doc in historySnapshot.docs) {
        history.add({
          ...doc.data(),
          'id': doc.data()['id'] ?? int.tryParse(doc.id) ?? doc.id,
        });
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Load Library Error: $e');
    }
  }

  // Add movie to Watchlist
  Future<void> addToWatchlist(Map<String, dynamic> movie) async {
    final userDocument = _userDocument;
    if (userDocument == null) return;

    final movieId = movie['id'];
    if (movieId == null) return;

    if (isInWatchlist(movieId)) return;

    watchlist.add(movie);
    notifyListeners();

    try {
      await userDocument
          .collection('watchlist')
          .doc(movieId.toString())
          .set(movie);
    } catch (e) {
      watchlist.removeWhere((item) => item['id'] == movieId);
      notifyListeners();
      debugPrint('Add Watchlist Error: $e');
    }
  }

  // Remove movie from Watchlist
  Future<void> removeFromWatchlist(dynamic movieId) async {
    final userDocument = _userDocument;
    if (userDocument == null) return;

    final removedMovies = watchlist
        .where((movie) => movie['id'] == movieId)
        .toList();

    watchlist.removeWhere((movie) => movie['id'] == movieId);
    notifyListeners();

    try {
      await userDocument
          .collection('watchlist')
          .doc(movieId.toString())
          .delete();
    } catch (e) {
      watchlist.addAll(removedMovies);
      notifyListeners();
      debugPrint('Remove Watchlist Error: $e');
    }
  }

  // Check if movie is saved
  bool isInWatchlist(dynamic movieId) {
    return watchlist.any((movie) => movie['id'] == movieId);
  }

  // Add movie to History
  Future<void> addToHistory(Map<String, dynamic> movie) async {
    final userDocument = _userDocument;
    if (userDocument == null) return;

    final movieId = movie['id'];
    if (movieId == null) return;

    history.removeWhere((item) => item['id'] == movieId);
    history.insert(0, movie);
    notifyListeners();

    try {
      await userDocument
          .collection('history')
          .doc(movieId.toString())
          .set({
        ...movie,
        'watchedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Add History Error: $e');
    }
  }

  // Remove movie from History
  Future<void> removeFromHistory(dynamic movieId) async {
    final userDocument = _userDocument;
    if (userDocument == null) return;

    history.removeWhere((movie) => movie['id'] == movieId);
    notifyListeners();

    try {
      await userDocument
          .collection('history')
          .doc(movieId.toString())
          .delete();
    } catch (e) {
      debugPrint('Remove History Error: $e');
    }
  }
}