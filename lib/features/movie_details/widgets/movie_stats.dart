import 'package:flutter/material.dart';
class MovieStats extends StatelessWidget {
  const MovieStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStat(
              icon: Icons.favorite,
              value: '15',
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: _buildStat(
              icon: Icons.access_time_filled,
              value: '90',
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: _buildStat(
              icon: Icons.star,
              value: '7.6',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String value,
  }) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xff303030),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xffFFC107),
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}