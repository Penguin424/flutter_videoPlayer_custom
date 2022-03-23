import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reproductor/src/models/etalle_examen_model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class ExamenesCalificacionesPage extends StatefulWidget {
  ExamenesCalificacionesPage({Key? key}) : super(key: key);

  @override
  State<ExamenesCalificacionesPage> createState() =>
      _ExamenesCalificacionesPageState();
}

class _ExamenesCalificacionesPageState
    extends State<ExamenesCalificacionesPage> {
  List<DetalleExamenModel> examenes = [];

  @override
  void initState() {
    handleGetExamenesDetalle();
    super.initState();
  }

  handleGetExamenesDetalle() async {
    await PreferenceUtils.init();

    await Future.delayed(Duration.zero, () async {
      final idExamen = ModalRoute.of(context)!.settings.arguments as int;
      final respuestasRes = await HttpMod.get(
        'detalleexamenes',
        {
          "_where[0][examen.id]": idExamen.toString(),
          "_limit": "100000",
        },
      );

      if (respuestasRes.statusCode == 200) {
        List<dynamic> examenDetalles = jsonDecode(respuestasRes.body);
        List<DetalleExamenModel> detalleExamenes = examenDetalles
            .map((json) => DetalleExamenModel.fromJson(json))
            .toList();

        setState(() {
          examenes = detalleExamenes;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Examen Detalle'),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
      ),
      body: examenes.length > 0
          ? ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                final examen = examenes[index];
                return ListTile(
                  title: Text(examen.alumno!.username!),
                  subtitle: Text(
                    "CALIFICACION: " + examen.calificacion!.toStringAsFixed(2),
                  ),
                  leading: Icon(Icons.person),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemCount: examenes.length,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
