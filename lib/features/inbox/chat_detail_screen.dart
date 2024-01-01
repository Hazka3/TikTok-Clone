import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            children: [
              const Positioned(
                child: Padding(
                  padding: EdgeInsets.all(Sizes.size4),
                  child: CircleAvatar(
                    radius: Sizes.size24,
                    foregroundImage: NetworkImage(
                        "https://avatars.githubusercontent.com/u/94900388?v=4"),
                    child: Text('は'),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 3, color: Colors.white),
                    color: Colors.green.shade400,
                  ),
                ),
              )
            ],
          ),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h28,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
          title: const Text(
            'はづか',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            'Active now',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }
}
