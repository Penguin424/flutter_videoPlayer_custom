import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/Colegiatura_model.dart';
import 'package:reproductor/src/models/Producto_model.dart';
import 'package:reproductor/src/models/User.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:intl/intl.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';
import 'package:simple_moment/simple_moment.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // const LoginPage({Key key}) : super(key: key);

  @override
  void initState() {
    super.initState();
    getInitDataAsync();
  }

  getInitDataAsync() async {
    await PreferenceUtils.init();

    final logged = PreferenceUtils.getBool('isLogged');

    if (logged) {
      final idUser = PreferenceUtils.getString('idUser');
      final role = PreferenceUtils.getString('role');
      final email = PreferenceUtils.getString('email');
      final password = PreferenceUtils.getString('password');

      final resCol = await HttpMod.get(
        'colegiaturas',
        {
          '_where[0][ColegiaturaAlumno.id]': idUser.toString(),
          '_sort': 'ColegiaturaFecha:DESC'
        },
      );
      final moment = new Moment.now().locale(new LocaleDe());

      List<Colegiatura> data = resCol.statusCode != 403 ||
              resCol.statusCode == 200
          ? jsonDecode(resCol.body).map<Colegiatura>((a) {
              return Colegiatura.fromJson(a);
            }).toList()
          : [
              Colegiatura(
                createdAt: DateTime.now(),
                colegiaturaFecha: moment.add(months: -3).format('MM/dd/yyyy'),
                id: 1,
                colegiaturaCantidad: 2600.toString(),
                updatedAt: DateTime.now(),
              ),
            ];

      final controller = Get.find<GlobalController>();

      final coolsArr = data
          .map(
            (e) => Timestamp.fromDate(
              DateFormat('MM/dd/yyyy').parse(e.colegiaturaFecha),
            ).millisecondsSinceEpoch,
          )
          .toList();

      final fechaMasGrande = coolsArr.reduce((a, b) => a > b ? a : b);

      final limite = DateTime(moment.year, moment.month, 10);
      final pago = DateTime.fromMillisecondsSinceEpoch(fechaMasGrande);

      final hoy = DateTime.now();

      if ((pago.month == limite.month && pago.year == limite.year) ||
          (hoy.day <= limite.day && pago.month == limite.month - 1)) {
        controller.onAddUltimoPago(pago);

        final resChat = await post(
          Uri.parse('https://chat.cosbiome.online/api/login'),
          body: jsonEncode(
            {
              'email': email,
              'password': password,
            },
          ),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );
        print(resChat.body);
        controller.onAddTokenChat(
          jsonDecode(resChat.body)['token'],
          jsonDecode(resChat.body)['usuario']['uid'],
          int.parse(idUser),
        );

        Navigator.pushNamed(context, '/home');
      } else if (role == 'MAESTRO') {
        controller.onAddUltimoPago(DateTime.now());

        final resChat = await post(
          Uri.parse('https://chat.cosbiome.online/api/login'),
          body: jsonEncode(
            {
              'email': email,
              'password': password,
            },
          ),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );
        print(resChat.body);
        controller.onAddTokenChat(
          jsonDecode(resChat.body)['token'],
          jsonDecode(resChat.body)['usuario']['uid'],
          int.parse(idUser),
        );

        Navigator.pushNamed(context, '/home');
      } else {
        controller.onAddShoppingCart(
          ProductoShoppingCart(
            price: controller.alumno.alumnoMensualidad!,
            canitdad: 1,
            id: controller.productos.length + 1,
            image:
                'https://i.pinimg.com/originals/dc/30/85/dc3085dbbc9897fc374f804d4649b502.png',
            name: 'COLEGIATURA',
            total: controller.alumno.alumnoMensualidad! * 1,
            canitdadAlamacen: 2,
            descripcion: 'Mensualidad',
          ),
          context,
        );

        Navigator.pushNamed(context, '/shoppingCar');
      }

      // Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        onRecoverPassword: (pass) async {
          return '';
        },
        loginAfterSignUp: false,
        onLogin: (value) async {
          final res = await HttpMod.login(value);
          if (res.statusCode == 200) {
            final user = User.fromJson(jsonDecode(res.body));
            final resCol = await HttpMod.get(
              'colegiaturas',
              {
                '_where[0][ColegiaturaAlumno.id]': user.user.id.toString(),
                '_sort': 'ColegiaturaFecha:DESC'
              },
            );
            final moment = new Moment.now().locale(new LocaleDe());

            List<Colegiatura> data =
                resCol.statusCode != 403 || resCol.statusCode == 200
                    ? jsonDecode(resCol.body).map<Colegiatura>((a) {
                        return Colegiatura.fromJson(a);
                      }).toList()
                    : [
                        Colegiatura(
                          createdAt: DateTime.now(),
                          colegiaturaFecha:
                              moment.add(months: -3).format('MM/dd/yyyy'),
                          id: 1,
                          colegiaturaCantidad: 2600.toString(),
                          updatedAt: DateTime.now(),
                        ),
                      ];

            final controller = Get.find<GlobalController>();

            final coolsArr = data
                .map(
                  (e) => Timestamp.fromDate(
                    DateFormat('MM/dd/yyyy').parse(e.colegiaturaFecha),
                  ).millisecondsSinceEpoch,
                )
                .toList();

            final fechaMasGrande = coolsArr.reduce((a, b) => a > b ? a : b);

            final limite = DateTime(moment.year, moment.month, 10);
            final pago = DateTime.fromMillisecondsSinceEpoch(fechaMasGrande);

            final hoy = DateTime.now();

            if ((pago.month == limite.month && pago.year == limite.year) ||
                (hoy.day <= limite.day && pago.month == limite.month - 1)) {
              controller.onAddUltimoPago(pago);

              final resChat = await post(
                Uri.parse('https://chat.cosbiome.online/api/login'),
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
              print(resChat.body);
              controller.onAddTokenChat(
                jsonDecode(resChat.body)['token'],
                jsonDecode(resChat.body)['usuario']['uid'],
                user.user.usuarioCursos.first.id,
              );

              Navigator.pushNamed(context, '/home');
            } else if (user.user.role.name == 'MAESTRO') {
              controller.onAddUltimoPago(DateTime.now());

              final resChat = await post(
                Uri.parse('https://chat.cosbiome.online/api/login'),
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
              print(resChat.body);
              controller.onAddTokenChat(
                jsonDecode(resChat.body)['token'],
                jsonDecode(resChat.body)['usuario']['uid'],
                user.user.usuarioCursos.first.id,
              );

              Navigator.pushNamed(context, '/home');
            } else {
              controller.onAddShoppingCart(
                ProductoShoppingCart(
                  price: controller.alumno.alumnoMensualidad!,
                  canitdad: 1,
                  id: controller.productos.length + 1,
                  image:
                      'https://i.pinimg.com/originals/dc/30/85/dc3085dbbc9897fc374f804d4649b502.png',
                  name: 'COLEGIATURA',
                  total: controller.alumno.alumnoMensualidad! * 1,
                  canitdadAlamacen: 2,
                  descripcion: 'Mensualidad',
                ),
                context,
              );

              Navigator.pushNamed(context, '/shoppingCar');
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
                HttpMod.localStorage.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
