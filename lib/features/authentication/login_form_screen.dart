import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
      ),
    );
  }
}
