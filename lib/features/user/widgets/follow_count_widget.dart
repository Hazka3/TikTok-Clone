import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class FollowCount extends StatelessWidget {
  final int count;

  final String title;

  const FollowCount({
    super.key,
    required this.count,
    required this.title,
  });

  String formatNumber(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(2)}K';
    } else {
      return count.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          formatNumber(count),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size18,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
