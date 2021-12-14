// ignore_for_file: camel_case_types

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:reproductor/src/models/AlumnoDB.dart';
import 'package:reproductor/src/models/DetalleTareaDB.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class ResumenTareasAlumnos extends StatefulWidget {
  ResumenTareasAlumnos({Key? key}) : super(key: key);

  @override
  _ResumenTareasAlumnosState createState() => _ResumenTareasAlumnosState();
}

class _ResumenTareasAlumnosState extends State<ResumenTareasAlumnos> {
  List<AlumnoDb> alumnos = [];
  int idCurso = 0;
  List<DetalleTareaDb> tareas = [];
  List<String> nombresTareas = [];

  @override
  void initState() {
    getAlumnos();
    super.initState();
  }

  void getAlumnos() {
    Future.delayed(Duration.zero, () async {
      final curso =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final alumnosDB = await HttpMod.get(
        '/users',
        {
          '_where[0][role.id]': '3',
          '_where[0][UsuarioCursos.id]': '${curso['idCurso']}',
          '_sort': 'username:ASC',
          '_limit': '100000',
        },
      );
      final tareasDB = await HttpMod.get("/detalletareas", {
        '_where[0][TareaDetTarea.TareaCurso]': curso['idCurso'].toString(),
        '_limit': '100000'
      });

      if (mounted) {
        setState(() {
          jsonDecode(alumnosDB.body).forEach((alumno) {
            alumnos.add(AlumnoDb.fromJson(alumno));
          });
          jsonDecode(tareasDB.body).forEach((tarea) {
            tareas.add(DetalleTareaDb.fromJson(tarea));
          });

          tareas.forEach((element) {
            if (!nombresTareas.contains(element.tareaDetTarea.tareaNombre)) {
              nombresTareas.add(element.tareaDetTarea.tareaNombre);
            }
          });

          idCurso = int.parse(curso['idCurso']);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _getFAB(),
      appBar: AppBar(
        backgroundColor: Color(0xFF4CAAB1),
        title: Text('Resumen de tareas'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: alumnos.length,
        itemBuilder: (context, index) {
          final alumno = alumnos[index];
          final tareasAlumno = tareas
              .where((tarea) => tarea.tareaDetAlumno.id == alumno.id)
              .toList();

          final promedio = tareasAlumno.length > 0
              ? tareasAlumno
                      .map((e) => e.tareaDetCalificacion)
                      .reduce((value, element) => value + element) /
                  tareasAlumno.length
              : 0;

          return ListTile(
            title: Text(alumno.username),
            subtitle:
                Text("PROMEDIO DE ENTREGABLES: " + promedio.toStringAsFixed(2)),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/resumenTareasAlumno/detalle',
                arguments: {
                  'alumno': alumno,
                  'idCurso': idCurso,
                },
              );
            },
            leading: CircleAvatar(
              backgroundColor: Color(0xFF4CAAB1),
              child: Text(
                alumno.username.substring(0, 1),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Color(0xFF4CAAB1),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
          child: Icon(
            Icons.border_all,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF4CAAB1),
          onTap: generarReporte,
          onLongPress: () {
            generarReporte();
          },
          label: 'Generar reporte en excel',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16.0,
          ),
          labelBackgroundColor: Color(0xFF4CAAB1),
        ),
      ],
    );
  }

  Future<void> generarReporte() async {
    try {
      int finalColumn = 0;
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Style globalStyle = workbook.styles.add('style');

      globalStyle.hAlign = HAlignType.center;
      globalStyle.vAlign = VAlignType.center;

      sheet.getRangeByIndex(1, 1).setText('ALUMNO');
      sheet.setColumnWidthInPixels(1, 500);
      sheet.getRangeByIndex(1, 1).cellStyle = globalStyle;
      final curso = alumnos.first.usuarioCursos.firstWhere(
        (element) => element.id == idCurso,
      );
      sheet.name = curso.cursoTitulo;

      for (var i = 0; i < nombresTareas.length; i++) {
        final nombre = nombresTareas[i];
        sheet.getRangeByIndex(1, i + 2).setText(nombre);
        sheet.setColumnWidthInPixels(i + 2, 500);
        sheet.getRangeByIndex(1, i + 2).cellStyle = globalStyle;

        finalColumn = i + 2;
      }
      for (var i = 0; i < alumnos.length; i++) {
        final alumno = alumnos[i];
        sheet.getRangeByIndex(i + 2, 1).setText(alumno.username);
        sheet.getRangeByIndex(i + 2, 1).cellStyle = globalStyle;

        for (var j = 0; j < nombresTareas.length; j++) {
          final nombre = nombresTareas[j];
          final tarea = tareas
              .where(
                (tarea) =>
                    tarea.tareaDetAlumno.id == alumno.id &&
                    tarea.tareaDetTarea.tareaNombre == nombre,
              )
              .toList();
          if (tarea.length > 0) {
            sheet
                .getRangeByIndex(i + 2, j + 2)
                .setNumber(tarea[0].tareaDetCalificacion.toDouble());

            sheet.getRangeByIndex(i + 2, j + 2).cellStyle = globalStyle;
          } else {
            sheet.getRangeByIndex(i + 2, j + 2).setNumber(0);
            sheet.getRangeByIndex(i + 2, j + 2).cellStyle = globalStyle;
          }
        }
      }
      sheet.getRangeByIndex(1, finalColumn + 1).setText('PROMEDIO');
      sheet.setColumnWidthInPixels(finalColumn + 1, 150);
      sheet.getRangeByIndex(1, finalColumn + 1).cellStyle = globalStyle;

      for (var i = 0; i < alumnos.length; i++) {
        final alumno = alumnos[i];
        final tareasAlumno = tareas
            .where((tarea) => tarea.tareaDetAlumno.id == alumno.id)
            .toList();

        final promedio = tareasAlumno.length > 0
            ? tareasAlumno
                    .map((e) => e.tareaDetCalificacion)
                    .reduce((value, element) => value + element) /
                tareasAlumno.length
            : 0;

        sheet
            .getRangeByIndex(i + 2, finalColumn + 1)
            .setNumber(promedio.toDouble());
        sheet.getRangeByIndex(i + 2, finalColumn + 1).cellStyle = globalStyle;
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      if (kIsWeb) {
        AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}',
        )
          ..setAttribute('download', 'ReporteCalificaciones.xlsx')
          ..click();
      } else {
        final String path = (await getApplicationSupportDirectory()).path;
        final String fileName =
            Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
        final File file = File(fileName);
        final fileFinal = await file.writeAsBytes(bytes, flush: true);
        await OpenFile.open(fileName);

        print(fileFinal);
      }
    } catch (e) {
      print(e);
    }
  }
}
