import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/features/users/view_models/avatar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final String uid;
  final bool hasAvatar;

  const Avatar({
    super.key,
    required this.name,
    required this.uid,
    required this.hasAvatar,
  });

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (imageFile != null) {
      final file = File(imageFile.path);
      ref.read(avatarProvider.notifier).uploadAvatarImage(file);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator.adaptive(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundImage: hasAvatar ? NetworkImage(
                  //NetwokrImage は画像をキャッシングするので、アバター画像を変更してもURLが同じであれば、profile画面では反映されない。
                  //この回避策として、URLにdataパラメータを任意で追加し、URLが都度変わるようにした
                  "https://firebasestorage.googleapis.com/v0/b/clone-tiktok-uryuryuc.appspot.com/o/avatars%2F$uid?alt=media&token=6d3b9884-c2dc-4965-9276-069bf6be19e6&date=${DateTime.now().toString()}") : null,
              child: Text(name),
            ),
    );
  }
}
