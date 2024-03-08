import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void onClosePressed() {
      Navigator.of(context).pop();
    }

    void onSavePressed() {
      Navigator.of(context).pop();
    }

    return ref.watch(usersProfileProvider).when(
        loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
        error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
        data: (data) {
          return Container(
            height: size.height * 0.94,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Sizes.size14),
                topRight: Radius.circular(Sizes.size14),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text("Edit Profile"),
                leading: IconButton(
                  onPressed: onClosePressed,
                  icon: const FaIcon(
                    FontAwesomeIcons.xmark,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size12,
                    ),
                    child: TextButton(
                      onPressed: onSavePressed,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: Sizes.size18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size20,
                    horizontal: Sizes.size40,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Avatar(
                            name: data.name,
                            uid: data.uid,
                            hasAvatar: data.hasAvatar,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 5,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.photoFilm,
                                size: Sizes.size20,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      Gaps.v20,
                      Container(
                        height: 1,
                        width: size.width,
                        color: Colors.grey.shade300,
                      ),
                      Gaps.v20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: size.width * 0.2,
                            child: const Text(
                              "name",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                          ),
                          Gaps.h20,
                          Expanded(
                            child: TextFormField(
                              autocorrect: false,
                              clipBehavior: Clip.hardEdge,
                              initialValue: data.name,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    Sizes.size12,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size12,
                                  vertical: Sizes.size10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gaps.v20,
                      Container(
                        height: 1,
                        width: size.width,
                        color: Colors.grey.shade300,
                      ),
                      Gaps.v20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: size.width * 0.2,
                            child: const Text(
                              "link",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                          ),
                          Gaps.h20,
                          Expanded(
                            child: TextFormField(
                              autocorrect: false,
                              initialValue: data.link,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    Sizes.size12,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size12,
                                  vertical: Sizes.size10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gaps.v20,
                      Container(
                        height: 1,
                        width: size.width,
                        color: Colors.grey.shade300,
                      ),
                      Gaps.v20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: size.width * 0.2,
                            child: const Text(
                              "bio",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                          ),
                          Gaps.h20,
                          Expanded(
                            child: SizedBox(
                              height: Sizes.size96 + Sizes.size96,
                              child: TextFormField(
                                initialValue: data.bio,
                                textAlignVertical: TextAlignVertical.top,
                                autocorrect: false,
                                expands: true,
                                minLines: null,
                                maxLines: null,
                                textInputAction: TextInputAction.newline,
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      Sizes.size12,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.size12,
                                    vertical: Sizes.size16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
