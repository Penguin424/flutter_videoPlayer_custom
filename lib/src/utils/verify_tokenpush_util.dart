import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class VerifyTokenPushUtil {
  static handleVerifyTokenPus() async {
    print('¿dasdasdasd');
    await PreferenceUtils.init();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();
    String tokenStorage = PreferenceUtils.getString('tokenPush');
    String userId = PreferenceUtils.getString('idUser');

    print('verificacionTo: ${token != tokenStorage && token != null}');

    print('token: $token');
    print('tokenStorage: $tokenStorage');

    if (token != null) {
      PreferenceUtils.putString('tokenPush', token);

      await HttpMod.update(
        'users/$userId',
        jsonEncode({
          "tokenpush": token,
        }),
      );
    }
  }
}
