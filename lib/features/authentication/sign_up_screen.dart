import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils/utils_darkmode.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "signup";
  static String routeURL = "/";

  const SignUpScreen({super.key});

  void _onLoginTap(BuildContext context) {
    context.pushNamed(LoginScreen.routeName);
  }

  void _onEmailTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
      ),
    );
    // Navigator.of(context).pushNamed(/
    // PageRouteBuilder(
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //     final offsetAnimation = Tween(
    //       begin: const Offset(-1, -1),
    //       end: Offset.zero,
    //     ).animate(animation);
    //     return SlideTransition(
    //       position: offsetAnimation,
    //       child: FadeTransition(
    //         opacity: animation,
    //         child: child,
    //       ),
    //     );
    //   },
    //   pageBuilder: (context, animation, secondaryAnimation) =>
    //       const UsernameScreen(),
    // ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size40,
              ),
              child: Column(
                children: [
                  Gaps.v80,
                  Text(
                    S.of(context).signUpTitle('TikTok'),
                    style: const TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v20,
                  Opacity(
                    opacity: 0.7,
                    child: Text(
                      S.of(context).signUpSubtitle,
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gaps.v40,
                  AuthButton(
                    tapButton: _onEmailTap,
                    text: S.of(context).emailPasswordButton,
                    icon: const FaIcon(
                      FontAwesomeIcons.user,
                    ),
                  ),
                  Gaps.v16,
                  AuthButton(
                    tapButton: _onEmailTap,
                    text: S.of(context).facebookButton,
                    icon: const FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Color(0xFF1877F2),
                    ),
                  ),
                  Gaps.v16,
                  AuthButton(
                    tapButton: _onEmailTap,
                    text: S.of(context).appleButton,
                    icon: const FaIcon(
                      FontAwesomeIcons.apple,
                    ),
                  ),
                  Gaps.v16,
                  AuthButton(
                    tapButton: _onEmailTap,
                    text: S.of(context).googleButton,
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                    ),
                  ),
                  Gaps.v16,
                  const FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: Sizes.size20,
                  ),
                  Gaps.v96,
                  Gaps.v24,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: Sizes.size12 + Sizes.size1,
                        color: isDarkMode(context)
                            ? Colors.grey.shade500
                            : Colors.black45,
                      ),
                      children: [
                        const TextSpan(
                          text: "By continuing, you agree to our ",
                        ),
                        TextSpan(
                          text: "Terms of Service",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isDarkMode(context)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: " and acknowledge that you have read our ",
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isDarkMode(context)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              " to learn how we collect, use, and share your data.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color:
              isDarkMode(context) ? Colors.grey.shade900 : Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.only(
              top: Sizes.size32,
              bottom: Sizes.size64,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).alreadyHaveAnAccount,
                ),
                Gaps.h5,
                GestureDetector(
                  onTap: () => _onLoginTap(context),
                  child: Text(
                    S.of(context).logIn,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
