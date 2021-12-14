import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reproductor/src/models/AlumnoDB.dart';
import 'package:reproductor/src/models/DetalleTareaDB.dart';
import 'package:reproductor/src/utils/Http.dart';

class ResumenTareasAlumnosDetalle extends StatefulWidget {
  ResumenTareasAlumnosDetalle({Key? key}) : super(key: key);

  @override
  _ResumenTareasAlumnosDetalleState createState() =>
      _ResumenTareasAlumnosDetalleState();
}

class _ResumenTareasAlumnosDetalleState
    extends State<ResumenTareasAlumnosDetalle> {
  List<DetalleTareaDb> tareas = [];
  AlumnoDb alumno = AlumnoDb.fromJson({
    "id": 0,
    "username": "",
    "email": "",
    "provider": "",
    "confirmed": false,
    "blocked": false,
    "role": {"id": 0, "name": "", "description": "", "type": ""},
    "created_at": "2021-08-13T15:24:01.000Z",
    "updated_at": "2021-08-13T15:24:01.000Z",
    "UsuarioFoto": "",
    "AlumnoApellidoPaterno": "",
    "AlumnoApellidoMaterno": "",
    "AlumnoNombres": "",
    "AlumnoFechaNacimiento": "",
    "AlumnoEstadoCivil": "",
    "AlumnoSexo": "",
    "AlumnoLugarDeNacimiento": "",
    "AlumnoEdad": "",
    "AlumnoEscuelaDeTransferencia": "",
    "AlumnoTipoDeSangre": "",
    "AlumnoTelefono": "",
    "AlumnoCelular": "",
    "AlumnoTelefonoDeEmergencia": "",
    "AlumnoDomicilio": "",
    "AlumnoCodiPostal": "",
    "AlumnoPais": "",
    "AlumnoEstado": "",
    "AlumnoMunicipio": "",
    "AlumnoRfc": "",
    "AlumnoCurp": "",
    "AlumnoMensualidad": "",
    "AlumnoCodigo": "",
    "AlumnoPresencial": false,
    "AlumnoLinea": false,
    "AlumnoVendedor": "s",
    "AlumnoPagoStripe": "",
    "AlumnoEgresado": false,
    "UsuarioCursos": [],
    "AlumnoTareas": [],
    "MaestroTarea": [],
    "MestroClases": [],
    "AlumnoAsistencias": [],
    "AlumnoColegiatura": []
  });
  double promedio = 0;

  @override
  void initState() {
    handleGetAlumnoTareas();
    super.initState();
  }

  void handleGetAlumnoTareas() {
    Future.delayed(Duration.zero, () async {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      final alumnoPass = arguments['alumno'] as AlumnoDb;
      final idCurso = arguments['idCurso'];

      final tareasDB = await HttpMod.get("/detalletareas", {
        '_where[0][TareaDetAlumno.id]': alumnoPass.id.toString(),
        '_where[0][TareaDetTarea.TareaCurso]': idCurso.toString(),
        '_limit': '100000',
      });

      print(tareasDB.body);
      print(idCurso);
      print(alumnoPass.id);

      setState(() {
        alumno = alumnoPass;
        tareas = (json.decode(tareasDB.body) as List)
            .map((e) => DetalleTareaDb.fromJson(e))
            .toList();

        promedio = tareas.length > 0
            ? tareas
                    .map((e) => e.tareaDetCalificacion)
                    .reduce((value, element) => value + element) /
                tareas.length
            : 0;
      });
    });
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4CAAB1),
        title: Text('Resumen de tareas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              alumno.username,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              height: size.height * 0.6,
              child: ListView.builder(
                itemCount: tareas.length,
                itemBuilder: (context, index) {
                  final tarea = tareas[index];
                  return ListTile(
                    title: Text(tarea.tareaDetTarea.tareaNombre),
                    trailing: Text(tarea.tareaDetCalificacion.toString()),
                    subtitle: Text(
                      'TAREA ENTREGADA: ' + tarea.createdAt.toString(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Promedio: $promedio',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
