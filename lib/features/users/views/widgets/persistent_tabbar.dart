import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/widgets/settings/common_setting.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils/utils_darkmode.dart';

class PersistentTabBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isDark = isDarkMode(context);
    return ValueListenableBuilder(
      valueListenable: darkModeConfig,
      builder: (context, value, child) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          border: Border.symmetric(
            horizontal: BorderSide(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
              width: 0.5,
            ),
          ),
        ),
        child: TabBar(
          indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
          indicatorSize: TabBarIndicatorSize.label,
          // labelColor: Colors.black,
          labelPadding: const EdgeInsets.symmetric(
            vertical: Sizes.size10,
          ),
          tabs: const [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.size12,
              ),
              child: Icon(Icons.grid_4x4_rounded),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.size12,
              ),
              child: FaIcon(FontAwesomeIcons.heart),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 47;

  @override
  double get minExtent => 47;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
