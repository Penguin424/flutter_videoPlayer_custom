import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reproductor/src/models/Asistencia_model.dart';
import 'package:reproductor/src/models/Clase_model.dart';
import 'package:reproductor/src/models/Curso.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AsistenciasTomaPage extends HookWidget {
  const AsistenciasTomaPage({
    required this.titleAppBar,
  }) : super();

  final ValueNotifier<String> titleAppBar;

  @override
  Widget build(BuildContext context) {
    final _asistencias = useState<List<Asistencia>>([]);
    final _claseSelect = useState<int>(0);
    final _clases = useState<List<Clase>>([]);
    final _alumnos = useState<List<CursoAlumno>>([]);
    final _curso = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );
    final _isLoading = useState<bool>(true);

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

        this.titleAppBar.value = 'ASISTENCIAS';
        _clases.value = data;
        _claseSelect.value = data[0].id;

        await _hanldeGetAsistencias(
            data[0].id.toString(), _asistencias, _isLoading);
      }
    }

    useEffect(() {
      handleGetInitData();
    }, []);

    useEffect(() {
      print(_asistencias.value.length);
    }, [_asistencias.value]);

    return LoadingOverlay(
      isLoading: _isLoading.value,
      color: Color(0xFF4CAAB1),
      opacity: 0.2,
      child: ListView(
        padding: EdgeInsets.all(20.0),
        children: _alumnos.value.length > 0
            ? [
                _clasesListas(
                  _claseSelect,
                  _clases,
                  _asistencias,
                  _isLoading,
                ),
                ..._alumnos.value
                    .where((element) => element.role == 3)
                    .map((e) {
                  return _listasCardsAsistencias(
                    e,
                    _asistencias,
                    _claseSelect,
                    _isLoading,
                  );
                }).toList()
              ]
            : [],
      ),
    );
  }

  Future<void> _hanldeGetAsistencias(
    String id,
    ValueNotifier<List<Asistencia>> _asistencias,
    ValueNotifier<bool> _isLoading,
  ) async {
    _isLoading.value = true;
    final resAsistencia = await HttpMod.get(
        '/asistencias', {'_where[0][AsistenciaClase.id]': id});

    if (resAsistencia.statusCode == 200) {
      List<Asistencia> data =
          jsonDecode(resAsistencia.body).map<Asistencia>((a) {
        return Asistencia.fromJson(a);
      }).toList();

      _asistencias.value = data;
      _isLoading.value = false;
    }
  }

  Container _listasCardsAsistencias(
    CursoAlumno e,
    ValueNotifier<List<Asistencia>> _asistencias,
    ValueNotifier<int> _claseSelect,
    ValueNotifier<bool> _isLoading,
  ) {
    List<Asistencia> veriAsis = _asistencias.value
        .where((asi) => asi.asistenciaAlumno.id == e.id)
        .toList();

    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            e.id.toString(),
            style: TextStyle(
              fontSize: kIsWeb ? 22 : 12,
            ),
          ),
          Text(
            e.username,
            style: TextStyle(
              fontSize: kIsWeb ? 22 : 12,
            ),
          ),
          Checkbox(
            value: veriAsis.length > 0 ? veriAsis[0].asistenciaCheck : false,
            onChanged: veriAsis.length > 0
                ? null
                : (value) async {
                    _isLoading.value = true;
                    final res = await HttpMod.post(
                      '/asistencias',
                      jsonEncode(
                        {
                          'asistenciaAlumno': e.id,
                          'asistenciaCheck': true,
                          'asistenciaClase': _claseSelect.value,
                          'asistenciaFecha': DateTime.now().toString(),
                        },
                      ),
                    );

                    // if (res.statusCode != 200) {
                    await _hanldeGetAsistencias(
                      _claseSelect.value.toString(),
                      _asistencias,
                      _isLoading,
                    );
                    // }
                  },
          )
        ],
      ),
    );
  }

  DropdownButton<int> _clasesListas(
    ValueNotifier<int> _claseSelect,
    ValueNotifier<List<Clase>> _clases,
    ValueNotifier<List<Asistencia>> _asistencias,
    ValueNotifier<bool> _isLoading,
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
      onChanged: (int? value) async {
        if (value != null) {
          await _hanldeGetAsistencias(
              value.toString(), _asistencias, _isLoading);
          _claseSelect.value = value;
        }
      },
    );
  }
}
