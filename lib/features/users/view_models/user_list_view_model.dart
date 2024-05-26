import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';

class UserListViewModel extends AsyncNotifier<List<UserProfileModel>> {
  late final UserRepository _userRepository;

  List<UserProfileModel> _list = [];

  @override
  FutureOr<List<UserProfileModel>> build() async {
    final user = ref.read(authRepo).user;

    _userRepository = ref.read(userRepo);

    final docs = await _userRepository.fetchUserList(user!.uid);
    _list = docs
        .map(
          (doc) => UserProfileModel.fromJson(
            doc.data(),
          ),
        )
        .toList();
    return _list;
  }
}

final userListProvider =
    AsyncNotifierProvider<UserListViewModel, List<UserProfileModel>>(
  () => UserListViewModel(),
);
