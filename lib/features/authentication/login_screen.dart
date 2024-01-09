import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_form_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _onSignupTap(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onEmailTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
      ),
    );
  }

  void _onEmailLoginTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size40,
          ),
          child: Column(
            children: [
              Gaps.v80,
              const Text(
                'Log in to TikTok',
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v20,
              const Opacity(
                opacity: 0.7,
                child: Text(
                  "Manage your account, cheek notifications, comment on videos, and more.",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.v40,
              AuthButton(
                tapButton: _onEmailLoginTap,
                text: "Use phone / email / username",
                icon: const FaIcon(
                  FontAwesomeIcons.user,
                ),
              ),
              Gaps.v16,
              AuthButton(
                tapButton: _onEmailTap,
                text: "Continue with Facebook",
                icon: const FaIcon(
                  FontAwesomeIcons.facebook,
                  color: Color(0xFF1877F2),
                ),
              ),
              Gaps.v16,
              AuthButton(
                tapButton: _onEmailTap,
                text: "Continue with Google",
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                ),
              ),
              Gaps.v32,
              const FaIcon(
                FontAwesomeIcons.chevronDown,
                size: Sizes.size20,
              ),
              Gaps.v96,
              Gaps.v96,
              Gaps.v20,
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
                        color:
                            isDarkMode(context) ? Colors.white : Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text: " and acknowledge that you have read our ",
                    ),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:
                            isDarkMode(context) ? Colors.white : Colors.black,
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
      bottomNavigationBar: Container(
        color: isDarkMode(context) ? Colors.grey.shade900 : Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.size32,
            bottom: Sizes.size64,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
              ),
              Gaps.h5,
              GestureDetector(
                onTap: () => _onSignupTap(context),
                child: Text(
                  "Sign up",
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
  }
}
