import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../editprofile/edit-profile-screen.dart';

import '../../library/providers/library_provider.dart';
import '../../library/widgets/library_movie_card.dart';

const kYellow = Color(0xFFF5B800);
const kRed = Color(0xFFE52521);
const kBg = Color(0xFF121212);
const kCard = Color(0xFF1F1F1F);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: kBg,
        body: Center(
          child: Text('Please login', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final library = context.watch<LibraryProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBg,
        // appBar: AppBar(
        //   backgroundColor: const Color(0xFF2B2B2B),
        //   centerTitle: true,
        //   title: const Text('Movies', style: TextStyle(color: Colors.white)),
        //   leading: const Icon(Icons.menu, color: Colors.white),
        // ),
        body: Column(
          children: [
            _Header(
              user: user,
              watchlistCount: library.watchlist.length,
              historyCount: library.history.length,
            ),

            Container(
              color: kCard,
              child: const TabBar(
                indicatorColor: kYellow,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                tabs: [
                  Tab(
                    icon: Icon(Icons.list, color: kYellow),
                    text: 'Watch List',
                  ),
                  Tab(
                    icon: Icon(Icons.folder, color: kYellow),
                    text: 'History',
                  ),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _MoviesGrid(movies: library.watchlist, isHistory: false),
                  _MoviesGrid(movies: library.history, isHistory: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final User user;
  final int watchlistCount;
  final int historyCount;

  const _Header({
    required this.user,
    required this.watchlistCount,
    required this.historyCount,
  });

  @override
  Widget build(BuildContext context) {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    return Container(
      color: kCard,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: userRef.snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data?.data() ?? {};

              final name = data['name'] ?? user.displayName ?? 'User';
              final photo = data['avatar'] ?? user.photoURL;

              return Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: const AssetImage(
                          'assets/Avatars/Avatar2.png',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _Counter(label: 'Wish List', count: watchlistCount),
                  const SizedBox(width: 28),
                  _Counter(label: 'History', count: historyCount),
                  const Spacer(),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen() ,
                      ),
                    );
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  label: const Text('Exit', style: TextStyle(fontSize: 16)),
                  icon: const Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  final String label;
  final int count;

  const _Counter({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _MoviesGrid extends StatelessWidget {
  final List<Map<String, dynamic>> movies;
  final bool isHistory;

  const _MoviesGrid({required this.movies, required this.isHistory});
  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(
        child: Text(
          isHistory ? 'No movies in history yet' : 'No movies in watchlist yet',
          style: const TextStyle(color: Colors.white54),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) {
        return LibraryMovieCard(movie: movies[index]);
      },
    );
  }
}
