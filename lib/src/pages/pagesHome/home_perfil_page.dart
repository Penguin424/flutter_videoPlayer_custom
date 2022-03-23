import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/Curso.dart';
import 'package:reproductor/src/models/Producto_model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class HomePerfil extends HookWidget {
  const HomePerfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medidas = MediaQuery.of(context).size;
    final _nombreList = useState<List<String>>(
      PreferenceUtils.getString('userName').toString().split(' ').toList(),
    );
    final _cursosAlumnos = useState<List<Curso>>([]);
    final _fotoPerfil =
        useState<String>(PreferenceUtils.getString('imagenPerfil').toString());

    void initGetDate() async {
      try {
        LocalStorage localStorage = LocalStorage('localStorage.json');
        final id = PreferenceUtils.getString('idUser');

        await PreferenceUtils.init();

        final res = await HttpMod.get(
          '/cursos',
          {
            '_where[0][CursoAlumnos.id]': id.toString(),
          },
        );

        if (res.statusCode == 200) {
          List<Curso> data = jsonDecode(res.body).map<Curso>((a) {
            return Curso.fromJson(a);
          }).toList();

          _cursosAlumnos.value = data;

          print(_cursosAlumnos.value);
        } else {}
      } catch (e) {
        print(e);
      }
    }

    useEffect(() {
      initGetDate();
    }, []);

    return GetBuilder<GlobalController>(
      builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: Column(
                      children: [
                        _fotoPerfil.value != 'no'
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(_fotoPerfil.value),
                                backgroundColor: Color(0xFF4CAAB1),
                                maxRadius: 120,
                              )
                            : CircleAvatar(
                                backgroundColor: Color(0xFF4CAAB1),
                                child: Text(
                                  '${_nombreList.value.first[0]}${_nombreList.value.last[0]}',
                                ),
                                maxRadius: 120,
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          PreferenceUtils.getString('userName').toString(),
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'CURSOS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Column(
                    children: _cursosAlumnos.value.map(
                      (c) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/clases',
                              arguments: {
                                'curso': c.id.toString(),
                                'cursoTitulo': c.cursoTitulo,
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                c.cursoTitulo,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Utlima clase tomada: ${c.cursoClases.last.claseTitulo}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(76, 170, 177, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                    onPressed: () async {
                      await PreferenceUtils.init();

                      PreferenceUtils.putString('token', '');
                      PreferenceUtils.putString('idUser', '');
                      PreferenceUtils.putString('userName', '');
                      PreferenceUtils.putString('role', '');
                      PreferenceUtils.putString('imagenPerfil', '');
                      PreferenceUtils.putBool('isLogged', false);
                      PreferenceUtils.putString('email', '');
                      PreferenceUtils.putString('password', '');

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        ModalRoute.withName('/'),
                      );
                    },
                    child: Text('Cerrar Sesión'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(76, 170, 177, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                    onPressed: _.ultimoPago.month == DateTime.now().month
                        ? null
                        : () {
                            _.onClearShoppingCart();
                            _.onAddShoppingCart(
                              ProductoShoppingCart(
                                price: _.alumno.alumnoMensualidad!,
                                canitdad: 1,
                                id: _.productos.length + 1,
                                image:
                                    'https://i.pinimg.com/originals/dc/30/85/dc3085dbbc9897fc374f804d4649b502.png',
                                name: 'COLEGIATURA',
                                total: _.alumno.alumnoMensualidad! * 1,
                                canitdadAlamacen: 2,
                                descripcion: 'Mensualidad',
                              ),
                              context,
                            );

                            Navigator.pushNamed(context, '/shoppingCar');
                          },
                    child: Text('PAGAR COLEGIATURA'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
