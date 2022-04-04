import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reproductor/src/models/Examenes_Model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class ExamenesCurso extends StatefulWidget {
  ExamenesCurso({
    Key? key,
    required this.idCurso,
    required this.titleAppBar,
  }) : super(key: key);

  final ValueNotifier<String> titleAppBar;
  final int idCurso;
  @override
  _ExamenesCursoState createState() => _ExamenesCursoState();
}

class _ExamenesCursoState extends State<ExamenesCurso> {
  List<ExamenesDb> examenes = [];

  @override
  void initState() {
    handleGetExamenes();
    super.initState();
  }

  void handleGetExamenes() async {
    final examenesDB = await HttpMod.get('/examenes', {
      '_where[0][curso.id]': widget.idCurso.toString(),
    });

    setState(
      () {
        examenes = jsonDecode(examenesDB.body)
            .map<ExamenesDb>(
              (json) => ExamenesDb.fromJson(json),
            )
            .toList();
        widget.titleAppBar.value = 'Examenes';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final examen = examenes[index];
            final intento = examen.detalleexamenes.where(
              (detalle) =>
                  detalle.alumno ==
                  int.parse(PreferenceUtils.getString('idUser')),
            );
            return intento.length > 0
                ? ListTile(
                    title: Text(examen.examenTitulo),
                    leading: Icon(Icons.book),
                    subtitle: Text(
                      'Calificación: ${intento.first.calificacion.toStringAsFixed(2)}',
                    ),
                    onTap: () {
                      if (PreferenceUtils.getString('role') == 'MAESTRO') {
                        Navigator.pushNamed(
                          context,
                          '/examen/detalle',
                          arguments: examen.id,
                        );
                      }
                    },
                  )
                : ListTile(
                    title: Text(examen.examenTitulo),
                    leading: Icon(Icons.book),
                    trailing: Icon(Icons.arrow_forward_ios),
                    subtitle: Text(
                      'Examen disponible',
                    ),
                    onTap: () {
                      if (PreferenceUtils.getString('role') == 'MAESTRO') {
                        Navigator.pushNamed(
                          context,
                          '/examen/detalle',
                          arguments: examen.id,
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/examen',
                          arguments: examenes[index],
                        );
                      }
                    },
                  );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemCount: examenes.length),
    );
  }
}
