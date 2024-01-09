import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/main_navigation/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(const TikTok());
}

class TikTok extends StatelessWidget {
  const TikTok({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "TikTok Clone",
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: Typography.whiteMountainView,
        splashFactory: NoSplash.splashFactory,
        primaryColor: const Color(0xFFE9435A),
        scaffoldBackgroundColor: Colors.black,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade900,
        ),
        tabBarTheme: const TabBarTheme(
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: Typography.blackCupertino,
        splashFactory: NoSplash.splashFactory,
        primaryColor: const Color(0xFFE9435A),
        scaffoldBackgroundColor: Colors.white,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        tabBarTheme: TabBarTheme(
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade500,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
