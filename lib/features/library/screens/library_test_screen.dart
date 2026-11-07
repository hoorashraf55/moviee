import 'package:flutter/material.dart';

import 'history_screen.dart';
import 'watchlist_screen.dart';

class LibraryTestScreen extends StatelessWidget {
  const LibraryTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121312),
      appBar: AppBar(
        backgroundColor: const Color(0xff121312),
        title: const Text(
          'My Library',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const WatchlistScreen(),
                    ),
                  );
                },
                child: const Text('Watchlist'),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const HistoryScreen(),
                    ),
                  );
                },
                child: const Text('History'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}