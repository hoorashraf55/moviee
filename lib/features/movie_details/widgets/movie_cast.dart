import 'package:flutter/material.dart';

class MovieCast extends StatelessWidget {
  const MovieCast({super.key});

  final List<Map<String, String>> cast = const [
    {
      'name': 'Hayley Atwell',
      'character': 'Captain Carter',
      'image': 'https://image.tmdb.org/t/p/w200/7U7s2z7l8l.jpg',
    },
    {
      'name': 'Elizabeth Olsen',
      'character': 'Wanda Maximoff / The Scarlet Witch',
      'image': 'https://image.tmdb.org/t/p/w200/4Y8.jpg',
    },
    {
      'name': 'Rachel McAdams',
      'character': 'Dr. Christine Palmer',
      'image': 'https://image.tmdb.org/t/p/w200/9G.jpg',
    },
    {
      'name': 'Charlize Theron',
      'character': 'Clea',
      'image': 'https://image.tmdb.org/t/p/w200/5.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...cast.map((actor) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xff343534),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      actor['image']!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey,
                          child: const Icon(Icons.person),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name : ${actor['name']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Character : ${actor['character']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}