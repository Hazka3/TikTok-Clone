import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/user/widgets/follow_count_widget.dart';
import 'package:tiktok_clone/features/user/widgets/persistent_tabbar.dart';
import 'package:tiktok_clone/features/user/widgets/social_button.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                width > Breakpoints.xl
                    ? SliverAppBar(
                        actions: [
                          IconButton(
                            onPressed: _onGearPressed,
                            icon: const FaIcon(
                              FontAwesomeIcons.gear,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      )
                    : SliverAppBar(
                        title: const Text("はづか"),
                        actions: [
                          IconButton(
                            onPressed: _onGearPressed,
                            icon: const FaIcon(
                              FontAwesomeIcons.gear,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
                SliverToBoxAdapter(
                  child: width > Breakpoints.xl
                      ? LayoutBuilder(
                          builder: (context, constraints) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size52,
                              vertical: Sizes.size20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 100,
                                  foregroundImage: NetworkImage(
                                    "https://avatars.githubusercontent.com/u/94900388?v=4",
                                  ),
                                  child: Text('はづか'),
                                ),
                                Gaps.h40,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          '@Hazka',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: Sizes.size32,
                                          ),
                                        ),
                                        Gaps.h5,
                                        FaIcon(
                                          FontAwesomeIcons.solidCircleCheck,
                                          size: Sizes.size28,
                                          color: Colors.blue.shade500,
                                        ),
                                      ],
                                    ),
                                    Gaps.v14,
                                    SizedBox(
                                      height: Sizes.size48,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const FollowCount(
                                            count: 37,
                                            title: "Following",
                                          ),
                                          VerticalDivider(
                                            color: Colors.grey.shade300,
                                            width: Sizes.size52,
                                            thickness: Sizes.size1,
                                            indent: Sizes.size14,
                                            endIndent: Sizes.size14,
                                          ),
                                          const FollowCount(
                                            count: 10525326,
                                            title: "Followers",
                                          ),
                                          VerticalDivider(
                                            color: Colors.grey.shade300,
                                            width: Sizes.size52,
                                            thickness: Sizes.size1,
                                            indent: Sizes.size14,
                                            endIndent: Sizes.size14,
                                          ),
                                          const FollowCount(
                                            count: 149253236,
                                            title: "Likes",
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gaps.v14,
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: Breakpoints.md / 2,
                                      ),
                                      child: const Row(
                                        children: [
                                          SocialButton(
                                            buttonType: ButtonType.followButton,
                                            child: Text(
                                              'Follow',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Gaps.h6,
                                          SocialButton(
                                            buttonType: ButtonType.iconButton,
                                            child: FaIcon(
                                              FontAwesomeIcons.youtube,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Gaps.h6,
                                          SocialButton(
                                            buttonType: ButtonType.iconButton,
                                            child: FaIcon(
                                              FontAwesomeIcons.ellipsis,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gaps.v14,
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: constraints.maxWidth / 2,
                                      ),
                                      child: const Text(
                                        'All highlights and where to watch live matches on FIFA+ I wonder how it would loooooooooooooooooooooooooooooooooooooooooooooooooook',
                                        style: TextStyle(
                                          fontSize: Sizes.size20,
                                        ),
                                      ),
                                    ),
                                    Gaps.v20,
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.link,
                                          size: Sizes.size12,
                                        ),
                                        Gaps.h4,
                                        Text(
                                          "https://github.com/Hazka3",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Gaps.v20,
                            const CircleAvatar(
                              radius: 50,
                              foregroundImage: NetworkImage(
                                "https://avatars.githubusercontent.com/u/94900388?v=4",
                              ),
                              child: Text('はづか'),
                            ),
                            Gaps.v14,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '@Hazka',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Sizes.size18,
                                  ),
                                ),
                                Gaps.h5,
                                FaIcon(
                                  FontAwesomeIcons.solidCircleCheck,
                                  size: Sizes.size16,
                                  color: Colors.blue.shade500,
                                ),
                              ],
                            ),
                            Gaps.v14,
                            SizedBox(
                              height: Sizes.size48,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FollowCount(
                                    count: 37,
                                    title: "Following",
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey.shade300,
                                    width: Sizes.size32,
                                    thickness: Sizes.size1,
                                    indent: Sizes.size14,
                                    endIndent: Sizes.size14,
                                  ),
                                  const FollowCount(
                                    count: 10525326,
                                    title: "Followers",
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey.shade300,
                                    width: Sizes.size32,
                                    thickness: Sizes.size1,
                                    indent: Sizes.size14,
                                    endIndent: Sizes.size14,
                                  ),
                                  const FollowCount(
                                    count: 149253236,
                                    title: "Likes",
                                  ),
                                ],
                              ),
                            ),
                            Gaps.v14,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size72 + Sizes.size4,
                              ),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: Breakpoints.md / 2,
                                ),
                                child: const Row(
                                  children: [
                                    SocialButton(
                                      buttonType: ButtonType.followButton,
                                      child: Text(
                                        'Follow',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Gaps.h6,
                                    SocialButton(
                                      buttonType: ButtonType.iconButton,
                                      child: FaIcon(
                                        FontAwesomeIcons.youtube,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Gaps.h6,
                                    SocialButton(
                                      buttonType: ButtonType.iconButton,
                                      child: FaIcon(
                                        FontAwesomeIcons.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Gaps.v14,
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Sizes.size32,
                              ),
                              child: Text(
                                'All highlights and where to watch live matches on FIFA+ I wonder how it would loooooooooooook',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Gaps.v14,
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.link,
                                  size: Sizes.size12,
                                ),
                                Gaps.h4,
                                Text(
                                  "https://github.com/Hazka3",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Gaps.v20,
                          ],
                        ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PersistentTabBar(),
                ),
              ];
            },
            body: TabBarView(
              children: [
                GridView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: 20,
                  padding: const EdgeInsets.only(
                    top: Sizes.size5,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width > Breakpoints.xl ? 5 : 3,
                    childAspectRatio: 3 / 4,
                    mainAxisSpacing: Sizes.size2,
                    crossAxisSpacing: Sizes.size2,
                  ),
                  itemBuilder: (context, index) => Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: "assets/images/placeholder.jpg",
                          image:
                              "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80",
                        ),
                      ),
                      const Positioned(
                        bottom: 0,
                        child: Row(
                          children: [
                            Icon(
                              Icons.play_arrow_outlined,
                              color: Colors.white,
                              size: Sizes.size28,
                            ),
                            Text(
                              '4.1M',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index == 0)
                        Positioned(
                          top: 4,
                          left: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size3),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(
                                Sizes.size2,
                              ),
                            ),
                            child: const Text(
                              'Pinned',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Sizes.size12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Center(
                  child: Text('page2'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
