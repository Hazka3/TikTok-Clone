import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();

  late TabController _tabController;

  String _searchWord = "";

  final tabs = [
    "Top",
    "Users",
    "Videos",
    "Sounds",
    "LIVE",
    "Shopping",
    "Brands",
  ];

  void _onStopSearch() {
    FocusScope.of(context).unfocus();
  }

  void _onClearTap() {
    _textEditingController.clear();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _onStopSearch();
      }
    });
    _textEditingController.addListener(() {
      setState(() {
        _searchWord = _textEditingController.text;
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDark = isDarkMode(context);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          title: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.sm,
            ),
            child: TextField(
              controller: _textEditingController,
              autocorrect: false,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "Search for...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Sizes.size8,
                  ),
                  borderSide: BorderSide.none,
                ),
                hintStyle: TextStyle(
                  color: isDarkMode(context)
                      ? Colors.grey.shade300
                      : Colors.black45,
                ),
                filled: true,
                fillColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                contentPadding: EdgeInsets.zero,
                icon: FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  size: Sizes.size24,
                  color: isDarkMode(context) ? Colors.white : Colors.black,
                ),
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: isDarkMode(context)
                          ? Colors.grey.shade300
                          : Colors.black,
                      size: Sizes.size18,
                    ),
                  ],
                ),
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchWord.isNotEmpty)
                      GestureDetector(
                        onTap: _onClearTap,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: Sizes.size16,
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.solidCircleXmark,
                            color: Colors.grey.shade500,
                            size: Sizes.size20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              alignment: Alignment.centerLeft,
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.sliders),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(
                Sizes.size6,
              ),
              itemCount: 20,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width > Breakpoints.lg ? 5 : 2,
                childAspectRatio: 9 / 20,
                mainAxisSpacing: Sizes.size10,
                crossAxisSpacing: Sizes.size10,
              ),
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constraints) => Column(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Sizes.size4,
                        ),
                      ),
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: "assets/images/placeholder.jpg",
                          image:
                              "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80",
                        ),
                      ),
                    ),
                    Gaps.v10,
                    const Text(
                      "This is a very long caption for my tiktok that im upload just now currently!!",
                      style: TextStyle(
                        fontSize: Sizes.size16 + Sizes.size2,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gaps.v8,
                    if (constraints.maxWidth < 210 ||
                        constraints.maxWidth > 260)
                      DefaultTextStyle(
                        style: TextStyle(
                          color: isDarkMode(context)
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(
                                "https://avatars.githubusercontent.com/u/94900388?v=4",
                              ),
                            ),
                            Gaps.h4,
                            const Expanded(
                              child: Text(
                                "My avatar is going to be very long!",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gaps.h4,
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: Sizes.size16,
                              color: Colors.grey.shade600,
                            ),
                            Gaps.h2,
                            const Text(
                              "2.5M",
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            for (var tab in tabs.skip(1))
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(
                    fontSize: Sizes.size28,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
