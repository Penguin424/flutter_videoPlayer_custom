import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:reproductor/src/components/Cards/card_detalleTarea.dart';
import 'package:reproductor/src/models/DetalleTareas_model.dart';
import 'package:reproductor/src/utils/Http.dart';

class RevisionTareas extends HookWidget {
  // const RevisionTareas({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isLoading = useState<bool>(true);
    final _tareas = useState<List<DetalleTareas>>([]);
    final _params = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );

    void handleGetDetTareas() async {
      final res = await HttpMod.get(
        '/detalletareas',
        {
          '_where[0][TareaDetTarea.id]': _params.value['idTarea'].toString(),
        },
      );

      if (res.statusCode == 200) {
        List<DetalleTareas> data = jsonDecode(res.body).map<DetalleTareas>((a) {
          return DetalleTareas.fromJson(a);
        }).toList();

        _tareas.value = data;
        _isLoading.value = false;
      }
    }

    useEffect(() {
      handleGetDetTareas();
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text('REVISION DE TAREAS'),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading.value,
        child: ListView(
          children: _tareas.value.length > 0
              ? _tareas.value.map((e) {
                  return CardTareaDetalle(
                    title: e.tareaDetAlumno.username,
                    descripcion: e.tareaDetTarea.tareaDescripcion,
                    id: e.id,
                    detalleTarea: e,
                  );
                }).toList()
              : [],
        ),
      ),
    );
  }
}
