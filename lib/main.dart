import 'package:flutter/material.dart';

void main() {
  runApp(const TikTok());
}

class TikTok extends StatelessWidget {
  const TikTok({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TikTok Clone",
      theme: ThemeData(
        primaryColor: const Color(0xFFE9435A),
      ),
      home: Container(),
    );
  }
}
