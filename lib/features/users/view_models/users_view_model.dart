import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersrepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    await Future.delayed(const Duration(seconds: 2));

    _usersrepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersrepository
          .findProfile(_authenticationRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }

    //UserProfileがない場合にリターン
    return UserProfileModel.empty();
  }

  Future<void> createProfile({
    required UserCredential credential,
    required String name,
    required String email,
    required String birthday,
  }) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      uid: credential.user!.uid,
      name: name,
      email: email,
      birthday: birthday,
      bio: "",
      link: "",
    );
    await _usersrepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}

final usersProfileProvider =
    AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
