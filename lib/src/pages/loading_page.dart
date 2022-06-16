import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/Colegiatura_model.dart';
import 'package:reproductor/src/models/Producto_model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:intl/intl.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';
import 'package:reproductor/src/utils/verify_tokenpush_util.dart';
import 'package:simple_moment/simple_moment.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    getInitDataAsync();
  }

  getInitDataAsync() async {
    try {
      await PreferenceUtils.init();

      final logged = PreferenceUtils.getBool('isLogged');

      if (logged) {
        final idUser = PreferenceUtils.getString('idUser');
        final role = PreferenceUtils.getString('role');
        final controller = Get.find<GlobalController>();

        if (role == 'PRUEBA') {
          controller.onAddTokenChat(
            PreferenceUtils.getString('token'),
            PreferenceUtils.getString('idUser'),
            int.parse(PreferenceUtils.getString('idUser')),
          );

          Navigator.pushReplacementNamed(context, '/home');

          return;
        }

        try {
          final resCol = await HttpMod.get(
            'colegiaturas',
            {
              '_where[0][ColegiaturaAlumno.id]': idUser.toString(),
              '_sort': 'ColegiaturaFecha:DESC'
            },
          );

          final moment = new Moment.now().locale(new LocaleDe());

          List<Colegiatura> data = resCol.statusCode == 200
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

            controller.onAddTokenChat(
              PreferenceUtils.getString('token'),
              PreferenceUtils.getString('idUser'),
              int.parse(PreferenceUtils.getString('idUser')),
            );

            if (!kIsWeb) {
              await VerifyTokenPushUtil.handleVerifyTokenPus();
            }

            if (resCol.statusCode == 200) {
              Navigator.pushNamed(context, '/home');
            } else {
              Navigator.pushNamed(context, '/login');
            }
          } else if (role == 'MAESTRO') {
            controller.onAddUltimoPago(DateTime.now());

            controller.onAddTokenChat(
              PreferenceUtils.getString('token'),
              PreferenceUtils.getString('idUser'),
              int.parse(PreferenceUtils.getString('idUser')),
            );

            if (!kIsWeb) {
              await VerifyTokenPushUtil.handleVerifyTokenPus();
            }

            if (resCol.statusCode == 200) {
              Navigator.pushNamed(context, '/home');
            } else {
              Navigator.pushNamed(context, '/login');
            }
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
        } catch (e) {
          await PreferenceUtils.init();

          PreferenceUtils.putString('token', '');
          PreferenceUtils.putString('idUser', '');
          PreferenceUtils.putString('userName', '');
          PreferenceUtils.putString('role', '');
          PreferenceUtils.putString('imagenPerfil', '');
          PreferenceUtils.putBool('isLogged', false);
          PreferenceUtils.putString('email', '');
          PreferenceUtils.putString('password', '');
          PreferenceUtils.putBool('isTest', false);
          PreferenceUtils.putString(
            'limitTest',
            '',
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            ModalRoute.withName('/'),
          );
        }
      } else {
        Navigator.pushNamed(context, '/login');
      }
    } catch (e) {
      await PreferenceUtils.init();

      PreferenceUtils.putString('token', '');
      PreferenceUtils.putString('idUser', '');
      PreferenceUtils.putString('userName', '');
      PreferenceUtils.putString('role', '');
      PreferenceUtils.putString('imagenPerfil', '');
      PreferenceUtils.putBool('isLogged', false);
      PreferenceUtils.putString('email', '');
      PreferenceUtils.putString('password', '');
      PreferenceUtils.putBool('isTest', false);
      PreferenceUtils.putString(
        'limitTest',
        '',
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        ModalRoute.withName('/'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Color(0xFF4CAAB1),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
