import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/chats_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;

    await _db.collection("users").doc(user!.uid).update({"token": token});
  }

  Future<void> initListeners(BuildContext context) async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    // Foreground
    // onMessage はアプリがforeground状態にある時のみ実行される
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      debugPrint("I just got a message and I'm in the foreground");
      debugPrint(event.notification?.title);
    });

    // Background
    // onMessageOpenedApp は、アプリがbackground状態にある時のみ実行される（terminated　ではない)
    // notification　引数について、なぜかRemoteMessageとtypeを指定してあげないとdebugPrintが実行されない
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage notification) {
      context.pushNamed(ChatsScreen.routeName);
    });

    // Terminated
    final notification = await _messaging.getInitialMessage();
    if (notification != null) {
      context.pushNamed(VideoRecordingScreen.routeName);
    }
  }

  @override
  FutureOr<void> build(BuildContext context) async {
    final token = await _messaging.getToken();
    if (token == null) return;

    await updateToken(token);

    await initListeners(context);

    //トークンが更新されるたびに通知を受けるため、onTokenRefresh ストリームに登録
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider.family(
  () => NotificationsProvider(),
);
