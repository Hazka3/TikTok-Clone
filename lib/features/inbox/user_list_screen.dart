import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/view_models/user_list_view_model.dart';
import 'package:tiktok_clone/utils/utils_darkmode.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => UserListScreenState();
}

class UserListScreenState extends ConsumerState<UserListScreen> {
  void _onUserTap(String uid) {}
  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Message"),
      ),
      body: ref.watch(userListProvider).when(
            data: (data) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size10,
                  horizontal: Sizes.size12,
                ),
                child: Column(
                  children: [
                    TextField(
                      autocorrect: false,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size12,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                        hintText: "Search user name!",
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              color:
                                  isDark ? Colors.grey.shade300 : Colors.black,
                              size: Sizes.size18,
                            ),
                          ],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Sizes.size12,
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size10,
                        ),
                        itemBuilder: (context, index) {
                          final user = data[index];
                          return ListTile(
                            onTap: () => _onUserTap(user.uid),
                            leading: CircleAvatar(
                              radius: 30,
                              foregroundImage: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/clone-tiktok-uryuryuc.appspot.com/o/avatars%2F${user.uid}?alt=media",
                              ),
                              child: Text(user.name),
                            ),
                            title: Text(
                              user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(user.bio),
                          );
                        },
                        itemCount: data.length,
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) => Center(
              child: Text(
                error.toString(),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
    );
  }
}
