import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils/utils_darkmode.dart';

enum ButtonType {
  followButton,
  iconButton,
}

class SocialButton extends StatelessWidget {
  final ButtonType buttonType;
  final Widget child;

  const SocialButton({
    super.key,
    required this.buttonType,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Expanded(
      flex: buttonType == ButtonType.followButton ? 4 : 1,
      child: Container(
        padding: buttonType == ButtonType.followButton
            ? const EdgeInsets.symmetric(
                vertical: Sizes.size16,
              )
            : const EdgeInsets.symmetric(
                vertical: Sizes.size12,
              ),
        decoration: BoxDecoration(
          color: buttonType == ButtonType.followButton
              ? Theme.of(context).primaryColor
              : Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              Sizes.size4,
            ),
          ),
          border: Border.all(
            color: isDark ? Colors.transparent : Colors.grey.shade400,
            width: 0.5,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
