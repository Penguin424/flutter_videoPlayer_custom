// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reproductor/src/models/AlumnoDB.dart';
import 'package:reproductor/src/models/DetalleTareaDB.dart';
import 'package:reproductor/src/utils/Http.dart';

class ResumenTareasAlumnos extends StatefulWidget {
  ResumenTareasAlumnos({Key? key}) : super(key: key);

  @override
  _ResumenTareasAlumnosState createState() => _ResumenTareasAlumnosState();
}

class _ResumenTareasAlumnosState extends State<ResumenTareasAlumnos> {
  List<AlumnoDb> alumnos = [];
  int idCurso = 0;

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
          '_sort': 'username:ASC'
        },
      );

      if (mounted) {
        setState(() {
          jsonDecode(alumnosDB.body).forEach((alumno) {
            alumnos.add(AlumnoDb.fromJson(alumno));
          });

          idCurso = int.parse(curso['idCurso']);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4CAAB1),
        title: Text('Resumen de tareas'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: alumnos.length,
        itemBuilder: (context, index) {
          final alumno = alumnos[index];

          return ListTile(
            title: Text(alumno.username),
            subtitle: Text(alumno.email),
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
}
