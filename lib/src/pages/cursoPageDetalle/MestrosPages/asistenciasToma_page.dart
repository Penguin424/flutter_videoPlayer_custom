import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reproductor/src/models/Asistencia_model.dart';
import 'package:reproductor/src/models/Clase_model.dart';
import 'package:reproductor/src/models/Curso.dart';
import 'package:reproductor/src/utils/Http.dart';

class AsistenciasTomaPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _asistencias = useState<List<Asistencia>>([]);
    final _claseSelect = useState<int>(0);
    final _clases = useState<List<Clase>>([]);
    final _alumnos = useState<List<CursoAlumno>>([]);
    final _curso = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );

    void handleGetInitData() async {
      final res = await HttpMod.get('/clases', {
        '_where[0][ClaseCurso.id]': _curso.value['curso'],
      });

      final resAlumnos = await HttpMod.get(
        '/cursos/${_curso.value['curso']}',
        {},
      );

      if (resAlumnos.statusCode == 200) {
        List<CursoAlumno> data =
            Curso.fromJson(jsonDecode(resAlumnos.body)).cursoAlumnos;

        _alumnos.value = data;
      } else {}

      if (res.statusCode == 200) {
        List<Clase> data = jsonDecode(res.body).map<Clase>((a) {
          return Clase.fromJson(a);
        }).toList();

        _clases.value = data;
        _claseSelect.value = data[0].id;

        final resAsistencia = await HttpMod.get('/asistencias',
            {'_where[0][AsistenciaClase.id]': data[0].id.toString()});

        if (resAsistencia.statusCode == 2) {
          List<Asistencia> data =
              jsonDecode(resAsistencia.body).map<Asistencia>((a) {
            return Asistencia.fromJson(a);
          }).toList();

          _asistencias.value = data;
        }
      } else {}
    }

    useEffect(() {
      handleGetInitData();
    }, []);

    return Container(
      child: ListView(
        padding: EdgeInsets.all(20.0),
        children: _alumnos.value.length > 0
            ? [
                _clasesListas(_claseSelect, _clases),
                ..._alumnos.value
                    .where((element) => element.role == 3)
                    .map((e) {
                  return _listasCardsAsistencias(e);
                }).toList()
              ]
            : [],
      ),
    );
  }

  Container _listasCardsAsistencias(CursoAlumno e) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            e.id.toString(),
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          Text(
            e.username,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          Checkbox(
            value: true,
            onChanged: (value) {},
          )
        ],
      ),
    );
  }

  DropdownButton<int> _clasesListas(
    ValueNotifier<int> _claseSelect,
    ValueNotifier<List<Clase>> _clases,
  ) {
    return DropdownButton<int>(
      icon: Icon(Icons.arrow_downward),
      value: _claseSelect.value,
      isExpanded: true,
      items: _clases.value.length > 0
          ? _clases.value.map((e) {
              return DropdownMenuItem<int>(
                value: e.id,
                child: Center(
                  child: Text(e.claseTitulo),
                ),
              );
            }).toList()
          : [
              DropdownMenuItem<int>(
                value: 0,
                child: Center(
                  child: Text('CLASE'),
                ),
              )
            ],
      onChanged: (int? value) {
        if (value != null) {
          _claseSelect.value = value;
        }
      },
    );
  }
}
