import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:localstorage/localstorage.dart';
import 'package:reproductor/src/models/Curso.dart';
import 'package:reproductor/src/utils/Http.dart';

class HomePerfil extends HookWidget {
  const HomePerfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medidas = MediaQuery.of(context).size;
    final _nombreList = useState<List<String>>(
      HttpMod.localStorage.getItem('userName').toString().split(' ').toList(),
    );
    final _cursosAlumnos = useState<List<Curso>>([]);
    final _fotoPerfil = useState<String>(
        HttpMod.localStorage.getItem('imagenPerfil').toString());

    void initGetDate() async {
      try {
        LocalStorage localStorage = LocalStorage('localStorage.json');
        final id = localStorage.getItem('idUser');

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
        } else {}
      } catch (e) {
        print(e);
      }
    }

    useEffect(() {
      initGetDate();
    }, []);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    _fotoPerfil.value != 'no'
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(_fotoPerfil.value),
                            backgroundColor: Color(0xFF4CAAB1),
                            maxRadius: medidas.width / 4,
                          )
                        : CircleAvatar(
                            backgroundColor: Color(0xFF4CAAB1),
                            child: Text(
                              '${_nombreList.value.first[0]}${_nombreList.value.last[0]}',
                            ),
                            maxRadius: medidas.width / 4,
                          ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      HttpMod.localStorage.getItem('userName').toString(),
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
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                child: Column(
                  children: _cursosAlumnos.value.map((c) {
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
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
