import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/utils/utils_firebase_error_snack.dart';

//このVMはアカウントを作成するとき roading 画面を見せ、アカウント作成をトリガーするだけの役割を果たすので、notifer は voidを返す
class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();

    // signUpFormの中身をロード
    final form = ref.read(signUpForm);

    // signup アカウントのuidに紐づくuserprofileを作成
    final users = ref.read(usersProfileProvider.notifier);

    state = await AsyncValue.guard(
      () async {
        final userCredential = await _authRepo.emailSignUp(
          form['email'],
          form['password'],
        );

        // userCredentialを元にuserを作成
        await users.createProfile(
          credential: userCredential,
          email: form['email'],
          name: form['name'],
          birthday: form['birthday'],
        );
      },
    );
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.goNamed(InterestsScreen.routeName);
    }
  }
}

// signup時に入力するメールアドレス、パスワードを保存するためのprovider
final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
