import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class RegistroPruebaPage extends StatefulWidget {
  RegistroPruebaPage({Key? key}) : super(key: key);

  @override
  State<RegistroPruebaPage> createState() => _RegistroPruebaPageState();
}

class _RegistroPruebaPageState extends State<RegistroPruebaPage> {
  final _formKey = GlobalKey<FormState>();
  String apellidoPaterno = '';
  String apellidoMaterno = '';
  String nombres = '';
  String celular = '';

  @override
  void initState() {
    handleGetInitData();
    super.initState();
  }

  handleGetInitData() async {
    await PreferenceUtils.init();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
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
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SafeArea(
                      child: Column(
                        children: [
                          const Text(
                            'BIENVENIDO A COSBIOME',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Registra tu cuenta de prueba\na cosmetología',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 20.0,
                      ),
                      constraints: BoxConstraints(
                        minHeight: size.height * 0.7,
                        maxHeight: size.height * 0.7,
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
                      child: Center(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      apellidoPaterno = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Apellido Paterno',
                                    labelStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 24,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Ingresa tu apellido paterno';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      apellidoMaterno = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Apellido Materno',
                                    labelStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 24,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Ingresa tu apellido materno';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      nombres = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Nombres',
                                    labelStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 24,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Ingresa tus nombres';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      celular = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Celular',
                                    labelStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 24,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Ingresa tu celular';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                  ),
                                  onPressed: _disabledSubmit,
                                  child: Text('crear cuenta'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _disabledSubmit() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'Las pruebas gratuitas no estan disponibles en este momento.\n\nPor favor, contacta con nosotros a través de nuestro WhatsApp o correo electrónico.\n\nGracias.',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // ignore: unused_element
  void _handleSubmit() async {
    try {
      if (_formKey.currentState!.validate()) {
        final dio = Dio();

        final clienteFind = await dio.get(
          'https://cosbiome.online/cosbiomeclientespautas?telefono=$celular',
        );

        if (clienteFind.statusCode == 200) {
          final clientes = clienteFind.data as List;

          if (clientes.length == 0) {
            await dio.post(
              'https://cosbiome.online/cosbiomeclientespautas',
              data: jsonEncode({
                'estatus': "SINASIGNAR",
                'fechamarcar': DateTime.now().toIso8601String(),
                'notasHistorial': '',
                'nota': '',
                'asignado': "5fa5b14e8e7a7a00171063f2",
                'pauta': "624c618d0ca59ed1e6bf3bb5",
                'nombre': '$apellidoPaterno $apellidoMaterno $nombres',
                'telefono': celular,
                'interest': 'CARRERA',
                'registradoPor': "APLICACION ESCUELA",
              }),
              options: Options(
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
            );
          } else {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    'Ya fuiste registrado para obtener tu prueba gratuita',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text('Aceptar'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          }

          final loginData = await HttpMod.login(
            LoginData(
              name: 'prueba.cosmetologia@cosbiome.com',
              password: 'PruPruCos5',
            ),
          );

          if (loginData.statusCode == 200) {
            PreferenceUtils.putBool('isTest', true);
            PreferenceUtils.putString(
              'limitTest',
              DateTime.now().add(Duration(days: 2)).toLocal().toString(),
            );

            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
