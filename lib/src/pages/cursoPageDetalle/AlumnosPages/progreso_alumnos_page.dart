import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:reproductor/src/models/Examenes_Model.dart';
import 'package:reproductor/src/models/Tarea.dart';
import 'package:reproductor/src/models/practica_model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class ProgresoAlumnosPage extends StatefulWidget {
  ProgresoAlumnosPage({
    required this.idCurso,
    required this.titleAppBar,
    Key? key,
  }) : super(key: key);
  final ValueNotifier<String> titleAppBar;
  final int idCurso;
  @override
  State<ProgresoAlumnosPage> createState() => _ProgresoAlumnosPageState();
}

class _ProgresoAlumnosPageState extends State<ProgresoAlumnosPage> {
  List<ExamenesDb> examenes = [];
  List<Tarea> tareas = [];
  List<PracticaModel> practicas = [];
  bool isLoading = true;
  int touchedIndex = 0;

  @override
  void initState() {
    handleGetData();

    super.initState();
  }

  List<double> handleCalculateTareasAndPracticas() {
    // 30 tareas y 30 practicas en puntaje para un total de 60 puntos

    final idAlumno = int.parse(
      PreferenceUtils.getString('idUser'),
    );
    List<double> listCalficaciones = [];
    List<double> listPracticas = [];
    List<TareaDetalle> detallesTareasList = [];
    List<PracticaModelDetallepracticas> detallesPracticasList = [];

    tareas.forEach((e) {
      e.tareaDetalles.forEach((element) {
        detallesTareasList.add(element);
      });
    });

    practicas.forEach((element) {
      element.detallepracticas!.forEach((e) {
        detallesPracticasList.add(e!);
      });
    });

    final detallesTareasEntregadas = detallesTareasList
        .where((element) => element.tareaDetAlumno == idAlumno)
        .toList();

    final detallesPracticasEntregadas = detallesPracticasList
        .where((element) => element.alumno == idAlumno)
        .toList();

    final diferenciaTareasTotal =
        tareas.length - detallesTareasEntregadas.length;

    final diferenciaPracticasTotal =
        practicas.length - detallesPracticasEntregadas.length;

    for (var i = 0; i < diferenciaTareasTotal; i++) {
      listCalficaciones.add(0.0);
    }

    for (var i = 0; i < diferenciaPracticasTotal; i++) {
      listPracticas.add(0.0);
    }

    detallesTareasEntregadas.forEach((element) {
      listCalficaciones.add(
        double.parse(
          element.tareaDetCalificacion.toString(),
        ),
      );
    });

    detallesPracticasEntregadas.forEach((element) {
      final calificacion = element.isAcreditada! ? 100.0 : 0.0;

      listPracticas.add(calificacion);
    });

    final sumaTareas = listCalficaciones.isNotEmpty
        ? listCalficaciones.reduce(
            (value, element) => value + element,
          )
        : 0;
    final sumaPracticas = listPracticas.isNotEmpty
        ? listPracticas.reduce(
            (value, element) => value + element,
          )
        : 0;

    final totaltareasle = tareas.isEmpty ? 1 : tareas.length;
    final totalpracticasle = practicas.isEmpty ? 1 : practicas.length;

    final promedioTareas = (sumaTareas / totaltareasle) / 100;
    final promedioPracticas = (sumaPracticas / totalpracticasle) / 100;

    final puntosSobre30Tareas = 30 * promedioTareas;
    final puntosSobre30Practicas = 30 * promedioPracticas;

    print("return ${[puntosSobre30Tareas, puntosSobre30Practicas]}");

    return [puntosSobre30Tareas, puntosSobre30Practicas];
  }

  handleGetData() async {
    try {
      final tareasDB = await HttpMod.get(
        'tareas',
        {
          "_where[0][TareaCurso.id]": widget.idCurso.toString(),
        },
      );
      final examenesDB = await HttpMod.get(
        'examenes',
        {
          '_where[0][curso.id]': widget.idCurso.toString(),
        },
      );
      final practicasDB = await HttpMod.get(
        'practicas',
        {
          '_where[0][curso.id]': widget.idCurso.toString(),
        },
      );

      setState(() {
        tareas = jsonDecode(tareasDB.body)
            .map<Tarea>((practica) => Tarea.fromJson(practica))
            .toList();
        examenes = jsonDecode(examenesDB.body)
            .map<ExamenesDb>((practica) => ExamenesDb.fromJson(practica))
            .toList();
        practicas = jsonDecode(practicasDB.body)
            .map<PracticaModel>((practica) => PracticaModel.fromJson(practica))
            .toList();

        isLoading = false;
      });

      widget.titleAppBar.value = 'PROGESO DE ACTIVIDADES';
    } catch (e) {
      print(e);
    }
  }

  double handleGetPuntosFromExamenes() {
    final idAlumno = int.parse(
      PreferenceUtils.getString('idUser'),
    );
    List<Detalleexamene> detalleExamenes = [];

    examenes.forEach((examen) {
      examen.detalleexamenes.forEach((detalle) {
        detalleExamenes.add(detalle);
      });
    });

    final detalleCurrent = detalleExamenes
        .where(
          (element) => element.alumno == idAlumno,
        )
        .toList();

    List<double> calificaciones = [];

    final diferencia = examenes.length - detalleCurrent.length;

    for (var i = 0; i < diferencia; i++) {
      calificaciones.add(0.0);
    }

    detalleCurrent.forEach((element) {
      calificaciones.add(element.calificacion);
    });

    final sumaCalificaciones = calificaciones.isNotEmpty
        ? calificaciones.reduce(
            (value, element) => value + element,
          )
        : 0;

    final totalexamenesle = examenes.isEmpty ? 1 : examenes.length;

    final promedio = ((sumaCalificaciones) / totalexamenesle) / 100;
    final puntos = 40 * promedio;

    print(puntos);

    return puntos;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'TAREAS DEL CURSO: ${tareas.length}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'PRACTICAS DEL CURSO: ${practicas.length}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'EXAMENES DEL CURSO: ${examenes.length}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    'PUNTOS OBTENIDOS\n${(handleCalculateTareasAndPracticas().reduce((value, element) => value + element) + handleGetPuntosFromExamenes()).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.4,
                    width: size.width,
                    child: PieChart(
                      PieChartData(
                        // pieTouchData: PieTouchData(touchCallback:
                        //     (FlTouchEvent event, pieTouchResponse) {
                        //   setState(() {
                        //     if (!event.isInterestedForInteractions ||
                        //         pieTouchResponse == null ||
                        //         pieTouchResponse.touchedSection == null) {
                        //       touchedIndex = -1;
                        //       return;
                        //     }
                        //     touchedIndex = pieTouchResponse
                        //         .touchedSection!.touchedSectionIndex;
                        //   });
                        // }),
                        // sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sections: [
                          PieChartSectionData(
                            title: handleCalculateTareasAndPracticas()[0]
                                .toStringAsFixed(2),
                            value: handleCalculateTareasAndPracticas()[0],
                            radius: 100,
                            color: Colors.orange,
                            titleStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            title: handleCalculateTareasAndPracticas()[1]
                                .toStringAsFixed(2),
                            value: handleCalculateTareasAndPracticas()[1],
                            radius: 100,
                            color: Colors.green,
                            titleStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            title: handleGetPuntosFromExamenes()
                                .toStringAsFixed(2),
                            value: handleGetPuntosFromExamenes(),
                            radius: 100,
                            color: Colors.pink[300],
                            titleStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            title: (100 -
                                    handleGetPuntosFromExamenes() -
                                    handleCalculateTareasAndPracticas().reduce(
                                      (value, element) => value + element,
                                    ))
                                .toStringAsFixed(2),
                            value: 100 -
                                handleGetPuntosFromExamenes() -
                                handleCalculateTareasAndPracticas().reduce(
                                  (value, element) => value + element,
                                ),
                            radius: 100,
                            color: Colors.red,
                            badgePositionPercentageOffset: .98,
                            titleStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      swapAnimationDuration: Duration(
                        milliseconds: 150,
                      ), // Optional
                      swapAnimationCurve: Curves.linear, // Optional
                    ),
                  ),
                  Container(
                    height: size.height * 0.2,
                    width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 12,
                                      width: 12,
                                      color: Colors.orange,
                                    ),
                                    Text(
                                      'TAREAS',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  handleCalculateTareasAndPracticas()[0]
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 12,
                                      width: 12,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      'PRACTICAS',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  handleCalculateTareasAndPracticas()[1]
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 12,
                                      width: 12,
                                      color: Colors.pink[300],
                                    ),
                                    Text(
                                      'EXAMENES',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  handleGetPuntosFromExamenes()
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 12,
                                      width: 12,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      'PUNTO FALTANTES',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  (100 -
                                          handleGetPuntosFromExamenes() -
                                          handleCalculateTareasAndPracticas()
                                              .reduce(
                                            (value, element) => value + element,
                                          ))
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    'Tareas: ${handleCalculateTareasAndPracticas()[0].toStringAsFixed(2)} puntos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    width: size.width,
                    height: size.height * 0.25,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final idAlumno = int.parse(
                          PreferenceUtils.getString('idUser'),
                        );
                        final tarea = tareas[index];
                        final fechaTarea =
                            DateTime.parse(tarea.createdAt.toString())
                                .toLocal()
                                .toString()
                                .split(" ")[0];
                        final tareaEntregada = tarea.tareaDetalles.where(
                          (element) => element.tareaDetAlumno == idAlumno,
                        );

                        return ListTile(
                          title: Text(
                            tarea.tareaNombre,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Fecha: $fechaTarea',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: tareaEntregada.isEmpty
                              ? Text(
                                  'Tarea no etregada',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CALIFICACION',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      tareaEntregada.first.tareaDetCalificacion
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.white,
                      ),
                      itemCount: tareas.length,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    'Practicas: ${handleCalculateTareasAndPracticas()[1].toStringAsFixed(2)} puntos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    width: size.width,
                    height: size.height * 0.25,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final idAlumno = int.parse(
                          PreferenceUtils.getString('idUser'),
                        );
                        final practica = practicas[index];
                        final fechaTarea =
                            DateTime.parse(practica.fecha.toString())
                                .toLocal()
                                .toString()
                                .split(" ")[0];
                        final practicaEntregada =
                            practica.detallepracticas!.where(
                          (element) => element!.alumno == idAlumno,
                        );

                        return ListTile(
                          title: Text(
                            practica.clase!.ClaseTitulo!,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Fecha: $fechaTarea',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: practicaEntregada.isEmpty
                              ? Text(
                                  'Practica no realizada',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  practicaEntregada.first!.isAcreditada!
                                      ? 'ACREDITADA'
                                      : 'NO ACREDITADA',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.white,
                      ),
                      itemCount: practicas.length,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    'Examenes: ${handleGetPuntosFromExamenes()} puntos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    width: size.width,
                    height: size.height * 0.25,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final idAlumno = int.parse(
                          PreferenceUtils.getString('idUser'),
                        );
                        final examen = examenes[index];
                        final fechaTarea =
                            DateTime.parse(examen.createdAt.toString())
                                .toLocal()
                                .toString()
                                .split(" ")[0];
                        final examenEntregado = examen.detalleexamenes.where(
                          (element) => element.alumno == idAlumno,
                        );

                        return ListTile(
                          title: Text(
                            examen.examenTitulo,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Fecha: $fechaTarea',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: examenEntregado.isEmpty
                              ? Text(
                                  'Examen no etregado',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CALIFICACION',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      examenEntregado.first.calificacion
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.white,
                      ),
                      itemCount: examenes.length,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
