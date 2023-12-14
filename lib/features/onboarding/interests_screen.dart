import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class InterestsScreen extends StatelessWidget {
  const InterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose your interests"),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.size24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v32,
            Text(
              "Choose your interests",
              style: TextStyle(
                fontSize: Sizes.size40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.v20,
            Text(
              "Get better video remommendations",
              style: TextStyle(
                fontSize: Sizes.size20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
