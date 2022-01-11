import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reproductor/src/components/Cards/card_tareas.dart';
import 'package:reproductor/src/models/Tarea.dart';
import 'package:reproductor/src/utils/Http.dart';

class TareasPage extends HookWidget {
  const TareasPage({
    required this.titleAppBar,
  }) : super();

  final ValueNotifier<String> titleAppBar;

  @override
  Widget build(BuildContext context) {
    final _tareas = useState<List<Tarea>>([]);
    final _curso = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );

    void handleGetTask() async {
      try {
        final res = await HttpMod.get('/tareas', {
          '_where[0][TareaCurso.id]': _curso.value['curso'],
          // '_where[0][TareaDetalles.TareaDetAlumno_ne]':
          //     HttpMod.localStorage.getItem('idUser').toString(),
          // '_where[0][TareaDetalles.TareaDetEntregada]': 'false',
        });

        if (res.statusCode == 200) {
          List<Tarea> data = jsonDecode(res.body).map<Tarea>((a) {
            return Tarea.fromJson(a);
          }).toList();

          List<TareaDetalle> detTareas = [];

          data.forEach((element) {
            final data = element.tareaDetalles
                .where(
                  (e) =>
                      e.tareaDetAlumno ==
                      HttpMod.localStorage.getItem('idUser'),
                )
                .toList();

            if (data.length > 0) {
              detTareas.add(data[0]);
            }
          });

          this.titleAppBar.value = detTareas.length > 0
              ? 'PUNTOS DE TAREAS: ' +
                  detTareas
                      .map((e) => e.tareaDetCalificacion)
                      .reduce((value, element) => value + element)
                      .toInt()
                      .toString()
              : 'TAREAS DEL CURSO';

          _tareas.value = data;
        }
      } catch (e) {}
    }

    useEffect(() {
      handleGetTask();
    }, []);

    return ListView(
      padding: EdgeInsets.all(5),
      children: _tareas.value.length > 0
          ? _tareas.value.map((tarea) {
              final det = tarea.tareaDetalles.where((element) {
                return element.tareaDetAlumno ==
                    HttpMod.localStorage.getItem('idUser');
              }).toList();
              // return Text('data');
              return CardTarea(
                title: tarea.tareaNombre,
                descripcion: tarea.tareaDescripcion,
                clase: tarea.tareaClase.claseTitulo,
                id: tarea.id,
                entr: det.length > 0 ? det[0].tareaDetEntregada : false,
                calificacion: det.length > 0 ? det[0].tareaDetCalificacion : 0,
                examen: tarea.tareaActiva,
              );
            }).toList()
          : [
              Center(
                child: Text('SIN TAREAS PENDIENTES'),
              ),
            ],
    );
  }
}
