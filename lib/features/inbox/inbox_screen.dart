import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  void _onDmPressed() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Inbox'),
        actions: [
          IconButton(
            onPressed: _onDmPressed,
            icon: const FaIcon(
              FontAwesomeIcons.paperPlane,
            ),
          ),
        ],
      ),
    );
  }
}
