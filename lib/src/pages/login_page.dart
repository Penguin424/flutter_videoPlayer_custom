import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/Colegiatura_model.dart';
import 'package:reproductor/src/models/User.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:intl/intl.dart';
import 'package:simple_moment/simple_moment.dart';

class LoginPage extends StatelessWidget {
  // const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        onRecoverPassword: (pass) async {
          return '';
        },
        hideSignUpButton: true,
        hideForgotPasswordButton: true,
        loginAfterSignUp: false,
        onLogin: (value) async {
          final res = await HttpMod.login(value);
          if (res.statusCode == 200) {
            final user = User.fromJson(jsonDecode(res.body));
            final resCol = await HttpMod.get(
              'colegiaturas',
              {
                '_where[0][ColegiaturaAlumno.id]': user.user.id.toString(),
                '_sort': 'ColegiaturaFecha:ASC'
              },
            );

            List<Colegiatura> data =
                jsonDecode(resCol.body).map<Colegiatura>((a) {
              return Colegiatura.fromJson(a);
            }).toList();

            final controller = Get.find<GlobalController>();

            final moment = new Moment.now().locale(new LocaleDe());
            final limite = DateTime(moment.year, moment.month, 10);
            final pago =
                DateFormat('MM/dd/yyyy').parse(data.last.colegiaturaFecha);

            final hoy = DateTime.now();

            if ((pago.month == limite.month && pago.year == limite.year) ||
                (hoy.day <= limite.day && pago.month == limite.month - 1)) {
              controller.onAddUltimoPago(pago);

              final resChat = await post(
                Uri.parse('http://192.168.68.124:8080/api/login'),
                body: jsonEncode(
                  {
                    'email': value.name,
                    'password': value.password,
                  },
                ),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              );

              controller.onAddTokenChat(
                jsonDecode(resChat.body)['token'],
                jsonDecode(resChat.body)['usuario']['uid'],
              );

              Navigator.pushNamed(context, '/home');
            } else {
              _showDialog(context, 'PLATAFORMA CERRADA');
            }
          } else {
            _showDialog(context, 'CONTRASEÑA O USUARIO INCORRECTOS');
          }
        },
        onSignup: (data) async {
          return '';
        },
        title: 'Escuela Cosbiome',
        theme: LoginTheme(
          titleStyle: TextStyle(
            fontSize: 26,
          ),
          pageColorLight: Color(0xFFBFE3ED),
          primaryColor: Color(0xFF4CAAB1),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context, String texto) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(texto),
          actions: [
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }
}
