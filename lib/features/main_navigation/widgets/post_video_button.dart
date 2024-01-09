import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class PostVideoButton extends StatelessWidget {
  final bool buttonHold;
  final int selectedIndex;

  const PostVideoButton({
    super.key,
    required this.buttonHold,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: 20,
          child: Container(
            height: 35,
            width: 25,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff61D4F0),
              borderRadius: BorderRadius.circular(
                Sizes.size8,
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          child: Container(
            height: 35,
            width: 25,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(
                Sizes.size8,
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size12,
          ),
          decoration: BoxDecoration(
            //Home画面でのみ colorが black ,他の画面では white を返す
            //かつ、buttonHold(押しっぱなしの時) = trueの時は、grey.shade400　を返す
            color: selectedIndex == 0 || isDark
                ? (buttonHold ? Colors.grey.shade400 : Colors.white)
                : (buttonHold ? Colors.grey.shade400 : Colors.black),
            borderRadius: BorderRadius.circular(
              Sizes.size8,
            ),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              //Home画面でのみ colorが white ,他の画面では black を返す
              //十字アイコンに関しては、画面・buttonHoldに関係なく常に white　を返す
              color: selectedIndex == 0 || isDark
                  ? (buttonHold ? Colors.white : Colors.black)
                  : Colors.white,
              size: Sizes.size16 + Sizes.size2,
            ),
          ),
        )
      ],
    );
  }
}
