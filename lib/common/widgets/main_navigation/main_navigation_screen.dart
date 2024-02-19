import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/discover/discover_screen.dart';
import 'package:tiktok_clone/features/inbox/inbox_screen.dart';
import 'package:tiktok_clone/features/main_navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone/features/main_navigation/widgets/post_video_button.dart';
import 'package:tiktok_clone/features/user/user_profile_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_timeline_screen.dart';
import 'package:tiktok_clone/utils/utils_darkmode.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = "mainNavigation";

  final String tab;

  const MainNavigationScreen({
    super.key,
    required this.tab,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "discover",
    "video",
    "inbox",
    "profile",
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab);

  bool _buttonHold = false;

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    context.pushNamed(VideoRecordingScreen.routeName);
  }

  void _onPostVideoButtonHold(detail) {
    setState(() {
      _buttonHold = !_buttonHold;
    });
  }

  void _onPostVideoButtonTapCancle() {
    setState(() {
      _buttonHold = false;
    });
  }

  //URLでダイレクト遷移した場合、画面が切り替わらないバグの修正
  @override
  void didUpdateWidget(covariant MainNavigationScreen oldScreen) {
    super.didUpdateWidget(oldScreen);
    if (widget.tab != oldScreen.tab) {
      setState(() {
        _selectedIndex = _tabs.indexOf(widget.tab);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const VideoTimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const DiscoverScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const InboxScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const UserProfileScreen(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.size20,
            bottom: Sizes.size32,
            right: Sizes.size24,
            left: Sizes.size24,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Row(
              mainAxisAlignment: (constraints.maxWidth > 1000)
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavTab(
                  text: "Home",
                  isSelected: _selectedIndex == 0,
                  icon: FontAwesomeIcons.house,
                  selectedIcon: FontAwesomeIcons.house,
                  selectedIndex: _selectedIndex,
                  onTap: () => _onTap(0),
                ),
                NavTab(
                  text: "Discover",
                  isSelected: _selectedIndex == 1,
                  icon: FontAwesomeIcons.compass,
                  selectedIcon: FontAwesomeIcons.solidCompass,
                  selectedIndex: _selectedIndex,
                  onTap: () => _onTap(1),
                ),
                GestureDetector(
                  onTap: _onPostVideoButtonTap,
                  onTapDown: _onPostVideoButtonHold,
                  onTapUp: _onPostVideoButtonHold,
                  onTapCancel: _onPostVideoButtonTapCancle,
                  child: PostVideoButton(
                    buttonHold: _buttonHold,
                    selectedIndex: _selectedIndex,
                  ),
                ),
                NavTab(
                  text: "Inbox",
                  isSelected: _selectedIndex == 3,
                  icon: FontAwesomeIcons.message,
                  selectedIcon: FontAwesomeIcons.solidMessage,
                  selectedIndex: _selectedIndex,
                  onTap: () => _onTap(3),
                ),
                NavTab(
                  text: "Profile",
                  isSelected: _selectedIndex == 4,
                  icon: FontAwesomeIcons.user,
                  selectedIcon: FontAwesomeIcons.solidUser,
                  selectedIndex: _selectedIndex,
                  onTap: () => _onTap(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
