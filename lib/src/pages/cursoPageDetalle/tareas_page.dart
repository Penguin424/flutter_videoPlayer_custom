import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reproductor/src/components/Cards/card_tareas.dart';
import 'package:reproductor/src/models/Tarea.dart';
import 'package:reproductor/src/utils/Http.dart';

class TareasPage extends HookWidget {
  // const TareasPage({}) : super();

  @override
  Widget build(BuildContext context) {
    final _tareas = useState<List<Tarea>>([]);
    final _curso = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );

    void handleGetTask() async {
      final res = await HttpMod.get('/tareas', {
        '_where[0][TareaCurso.id]': _curso.value['curso'],
        '_where[0][TareaDetalles.TareaDetAlumno_ne]':
            HttpMod.localStorage.getItem('idUser').toString(),
        // '_where[0][TareaDetalles.TareaDetEntregada]': 'false',
      });

      if (res.statusCode == 200) {
        List<Tarea> data = jsonDecode(res.body).map<Tarea>((a) {
          return Tarea.fromJson(a);
        }).toList();

        _tareas.value = data;
      }
    }

    useEffect(() {
      handleGetTask();
    }, []);

    return ListView(
      padding: EdgeInsets.all(5),
      children: _tareas.value.length > 0
          ? _tareas.value.map((tarea) {
              return CardTarea(
                title: tarea.tareaNombre,
                descripcion: tarea.tareaDescripcion,
                clase: tarea.tareaClase.claseTitulo,
                id: tarea.id,
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
