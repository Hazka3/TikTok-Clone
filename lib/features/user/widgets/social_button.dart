import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

enum ButtonType {
  followButton,
  iconButton,
}

class SocialButton extends StatelessWidget {
  final ButtonType? buttonType;
  final Widget child;

  const SocialButton({
    super.key,
    required this.buttonType,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
              Sizes.size2,
            ),
          ),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 0.5,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
