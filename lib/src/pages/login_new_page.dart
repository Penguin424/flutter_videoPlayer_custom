import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/controllers/notificaciones_controller.dart';
import 'package:reproductor/src/models/Colegiatura_model.dart';
import 'package:reproductor/src/models/Producto_model.dart';
import 'package:reproductor/src/models/User.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';
import 'package:reproductor/src/utils/verify_tokenpush_util.dart';
import 'package:simple_moment/simple_moment.dart';

class LoginNewPage extends StatefulWidget {
  LoginNewPage({Key? key}) : super(key: key);

  @override
  State<LoginNewPage> createState() => _LoginNewPageState();
}

class _LoginNewPageState extends State<LoginNewPage> {
  String _email = '';
  String _password = '';
  bool isHIddenText = true;
  bool _isLoading = false;
  bool _visible = true;
  late Timer _timer;
  final _formKey = GlobalKey<FormState>();
  final notiContoller = Get.find<NotificacionesContoller>();

  void initState() {
    _validPreferences();
    getInitDataAsync();

    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        setState(() {
          _visible = !_visible;
        });
      },
    );
    super.initState();
  }

  Future<void> _validPreferences() async {
    await PreferenceUtils.init();
    bool isLogged = PreferenceUtils.getBool('isLogged');

    if (isLogged) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  getInitDataAsync() async {
    await PreferenceUtils.init();

    final logged = PreferenceUtils.getBool('isLogged');

    if (logged) {
      final idUser = PreferenceUtils.getString('idUser');
      final role = PreferenceUtils.getString('role');

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

        controller.onAddTokenChat(
          PreferenceUtils.getString('token'),
          PreferenceUtils.getString('idUser'),
          int.parse(PreferenceUtils.getString('idUser')),
        );

        if (!kIsWeb) {
          await VerifyTokenPushUtil.handleVerifyTokenPus();
        }

        Navigator.pushNamed(context, '/home');
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
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary,
              ],
            ),
          ),
          child: Center(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SafeArea(
                        child: Column(
                          children: [
                            AnimatedOpacity(
                              opacity: _visible ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 2000),
                              child: Image.asset(
                                'assets/logo.png',
                                height: size.height * 0.1,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'BIENVENIDO A COSBIOME',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Inicia sesion',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        // height: size.height * 0.5,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 20.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3.0,
                              offset: Offset(
                                0.0,
                                5.0,
                              ),
                              spreadRadius: 3.0,
                            )
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Ingresa tu correo';
                                  }
                                  return null;
                                },
                                onChanged: (value) => setState(() {
                                  _email = value;
                                }),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(36.0),
                                  ),
                                  prefixIcon: _email.isNotEmpty
                                      ? null
                                      : Padding(
                                          padding: const EdgeInsets.all(
                                            12.0,
                                          ), // add padding to adjust icon
                                          child: Row(
                                            children: const [
                                              Icon(Icons.person),
                                              SizedBox(width: 8),
                                              Text(
                                                'Correo electrónico',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Ingresa tu contraseña';
                                  }
                                  return null;
                                },
                                onChanged: (value) => setState(() {
                                  _password = value;
                                }),
                                obscureText: isHIddenText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(36.0),
                                  ),
                                  prefixIcon: _password.isNotEmpty
                                      ? null
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: const [
                                                  Icon(Icons.lock_outlined),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Contraseña',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                icon: Icon(isHIddenText
                                                    ? Icons.remove_red_eye
                                                    : Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    isHIddenText =
                                                        !isHIddenText;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                  suffixIcon: _password.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(isHIddenText
                                              ? Icons.remove_red_eye
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              isHIddenText = !isHIddenText;
                                            });
                                          },
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(36.0),
                                  ),
                                ),
                                onPressed: _isLoading ? null : _handleSubmit,
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      )
                                    : const Text(
                                        'Iniciar sesión',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 32,
                                width: size.width,
                                child: Divider(height: 3, color: Colors.grey),
                              ),
                              const Text(
                                'Obten una prueba gratuita con este boton',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(36.0),
                                  ),
                                ),
                                onPressed: kIsWeb
                                    ? null
                                    : () async {
                                        Navigator.pushNamed(
                                          context,
                                          '/registro/prueba',
                                        );
                                      },
                                child: Text('Prueba gratuita'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final loginData = await HttpMod.login(
        LoginData(
          name: _email,
          password: _password,
        ),
      );

      if (loginData.statusCode == 200) {
        // Navigator.pushReplacementNamed(context, '/home');
        final user = User.fromJson(jsonDecode(loginData.body));
        final resCol = await HttpMod.get(
          'colegiaturas',
          {
            '_where[0][ColegiaturaAlumno.id]': user.user.id.toString(),
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

          controller.onAddTokenChat(
            user.jwt,
            user.user.id.toString(),
            user.user.usuarioCursos.first.id,
          );
          if (!kIsWeb) {
            await VerifyTokenPushUtil.handleVerifyTokenPus();
          }
          await notiContoller.handleGetCurrentUser();

          Navigator.pushNamed(context, '/home');
        } else if (user.user.role.name == 'MAESTRO') {
          controller.onAddUltimoPago(DateTime.now());

          controller.onAddTokenChat(
            user.jwt,
            user.user.id.toString(),
            user.user.usuarioCursos.first.id,
          );

          if (!kIsWeb) {
            await VerifyTokenPushUtil.handleVerifyTokenPus();
          }
          await notiContoller.handleGetCurrentUser();

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
      setState(() {
        _isLoading = false;
      });
    }
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
                Navigator.pushNamed(context, '/login');
                HttpMod.localStorage.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
