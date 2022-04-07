import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/models/user_chat_model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class NotificacionesContoller extends GetxController {
  Rx<FirebaseMessaging> messaging = FirebaseMessaging.instance.obs;
  Rx<UserChatModel> userChat = UserChatModel().obs;

  @override
  void onInit() async {
    super.onInit();

    handleGetCurrentUser();

    final settings = await messaging.value.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    if (AuthorizationStatus.authorized == settings.authorizationStatus) {
      AwesomeNotifications().actionStream.listen(
        (action) {
          final userMap = jsonDecode(
            jsonDecode(action.payload!['data'] as String)['usserMessage'],
          );

          final userNoti = UserChatModel.fromJson(
            userMap,
          );

          Navigator.pushNamed(Get.context!, '/chat', arguments: userNoti);
        },
      );

      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {
          if (message.notification != null && !kIsWeb) {
            if (message.notification!.android!.imageUrl != null ||
                message.notification!.android!.imageUrl != '' ||
                message.notification!.apple!.imageUrl != null ||
                message.notification!.apple!.imageUrl != '') {
              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 1,
                  channelKey: 'key1',
                  title: message.notification!.title,
                  body: message.notification!.body,
                  color: Theme.of(Get.context!).colorScheme.primary,
                  bigPicture: message.notification!.android!.imageUrl ??
                      message.notification!.apple!.imageUrl,
                  notificationLayout: NotificationLayout.BigPicture,
                  payload: {
                    "data": jsonEncode(message.data),
                  },
                ),
                actionButtons: [
                  NotificationActionButton(
                    key: 'asdasdas',
                    label: 'Aceptar',
                    buttonType: ActionButtonType.KeepOnTop,
                  ),
                ],
              );
            } else if (message.notification!.body!.startsWith('https://')) {
              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 1,
                  channelKey: 'key1',
                  title: message.notification!.title,
                  color: Theme.of(Get.context!).colorScheme.primary,
                  bigPicture: message.notification!.body,
                  notificationLayout: NotificationLayout.BigPicture,
                  payload: {
                    "data": jsonEncode(message.data),
                  },
                ),
                actionButtons: [
                  NotificationActionButton(
                    key: 'asdasdas',
                    label: 'Aceptar',
                    buttonType: ActionButtonType.KeepOnTop,
                  ),
                ],
              );
            } else {
              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 1,
                  channelKey: 'key1',
                  title: message.notification!.title,
                  body: message.notification!.body,
                  color: Theme.of(Get.context!).colorScheme.primary,
                  payload: {
                    "data": jsonEncode(message.data),
                  },
                ),
                actionButtons: [
                  NotificationActionButton(
                    key: 'asdasdas',
                    label: 'Aceptar',
                    buttonType: ActionButtonType.KeepOnTop,
                  ),
                ],
              );
            }
          }
        },
      );
    }
  }

  handleGetCurrentUser() async {
    await PreferenceUtils.init();

    if (PreferenceUtils.getBool('isLogged')) {
      final userDB = await HttpMod.get(
        'users/${PreferenceUtils.getString("idUser")}',
        {},
      );

      final userDBMap = jsonDecode(userDB.body);

      final user = UserChatModel.fromJson(
        userDBMap,
      );

      userChat.value = user;
    }
  }
}
