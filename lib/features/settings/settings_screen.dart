import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/settings/common_setting.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/utils.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.sm,
          ),
          child: ListView(
            children: [
              AnimatedBuilder(
                animation: darkModeConfig,
                builder: (context, child) => SwitchListTile.adaptive(
                  value: darkModeConfig.value,
                  onChanged: (value) {
                    darkModeConfig.value = !darkModeConfig.value;
                  },
                  title: const Text(
                    "Dark Mode",
                  ),
                  subtitle: const Text(
                    "Change theme Dark Mode.",
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).muted,
                onChanged: (value) =>
                    ref.read(playbackConfigProvider.notifier).setMuted(value),
                title: const Text(
                  "Mute Video",
                ),
                subtitle: const Text(
                  "Video will be muted by default.",
                ),
              ),
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).autoplay,
                onChanged: (value) => ref
                    .read(playbackConfigProvider.notifier)
                    .setAutoplay(value),
                title: const Text(
                  "Autoplay",
                ),
                subtitle: const Text(
                  "Video will start playing automatically.",
                ),
              ),
              SwitchListTile.adaptive(
                value: false,
                onChanged: (value) {},
                title: const Text(
                  "Enable notifications",
                ),
                subtitle: const Text(
                  "They will be cute",
                ),
              ),
              CheckboxListTile(
                activeColor: isDarkMode(context) ? Colors.white : Colors.black,
                value: false,
                onChanged: (value) {},
                title: const Text(
                  'Enable notifications',
                ),
              ),
              ListTile(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1980),
                    lastDate: DateTime(2030),
                  );
                  if (kDebugMode) {
                    print(date);
                  }
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (kDebugMode) {
                    print(time);
                  }
                  final booking = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(1980),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData(
                          appBarTheme: const AppBarTheme(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (kDebugMode) {
                    print(booking);
                  }
                },
                title: const Text("What is your birthday?"),
                subtitle: const Text("I need to know!"),
              ),
              ListTile(
                title: const Text('Log out (iOS)'),
                textColor: Colors.red,
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text(
                        'Are you sure?',
                      ),
                      content: const Text(
                        'Please dont go TT',
                      ),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(),
                          isDefaultAction: true,
                          textStyle: const TextStyle(
                            color: Colors.blue,
                          ),
                          child: const Text(
                            'No',
                          ),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            ref.read(authRepo).signOut();
                            context.go("/");
                          },
                          isDestructiveAction: true,
                          child: const Text(
                            'Yes',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Log out (Android)'),
                textColor: Colors.red,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      icon: const FaIcon(
                        FontAwesomeIcons.skull,
                      ),
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor,
                      title: const Text(
                        'Are you sure?',
                      ),
                      content: const Text(
                        'Please dont go TT',
                      ),
                      actions: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const FaIcon(FontAwesomeIcons.car),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Yes',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Log out (iOS / Bottom)'),
                textColor: Colors.red,
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: const Text(
                        'Are you sure?',
                      ),
                      message: const Text(
                        'Please dooooont goooooooooo',
                      ),
                      actions: [
                        CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () => Navigator.of(context).pop,
                          child: const Text(
                            'Not log out',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () => Navigator.of(context).pop,
                          child: const Text(
                            'Yes plz',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const AboutListTile(
                applicationVersion: "1.0",
                applicationLegalese: "Don't copy me.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
