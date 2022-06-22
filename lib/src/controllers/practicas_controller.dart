import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/models/Curso.dart';
import 'package:reproductor/src/models/practica_model.dart';
import 'package:reproductor/src/utils/Http.dart';

class PracticasController extends GetxController {
  RxList<PracticaModel> practicas = RxList<PracticaModel>();
  late Rx<Curso> curso;
  RxList<CursoAlumno> cursoAlumnos = RxList<CursoAlumno>();
  late Rx<CursoClase> cursoClase;
  Rx<DateTime> fechaPractica = DateTime.now().obs;
  RxDouble precio = 0.0.obs;
  late Rx<PracticaModel> practica;

  handleUpdatePracticas(int id) async {
    try {
      await HttpMod.update(
        'detallepracticas/$id',
        jsonEncode(
          {
            'isAcreditada': true,
          },
        ),
      );

      final indexDetalle = practica.value.detallepracticas!.indexWhere(
        (element) => element!.id == id,
      );

      practica.value.detallepracticas![indexDetalle]!.isAcreditada = true;

      Get.snackbar(
        'Practica acreditada',
        'Practica acreditada con exito',
        icon: Icon(Icons.check),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print(e);
    }
  }

  handleGetPracticas() async {
    try {
      final practicasDB = await HttpMod.get(
        'practicas',
        {
          '_limit': '100000',
          '_where[0][curso.id]': curso.value.id.toString(),
        },
      );

      final practicasmodel = jsonDecode(practicasDB.body)
          .map<PracticaModel>((practica) => PracticaModel.fromJson(practica))
          .toList();

      practicas.value = practicasmodel;

      update();
    } catch (e) {}
  }

  handleCreatePractica(BuildContext context) async {
    try {
      await HttpMod.post(
        'practicas',
        jsonEncode(
          {
            'clase': cursoClase.value.id,
            'costo': precio.value,
            'fecha': fechaPractica.value.toIso8601String(),
            'alumnos': cursoAlumnos.map((e) => e.id).toList(),
            'curso': curso.value.id,
          },
        ),
      );

      cursoAlumnos.value = [];
      precio.value = 0.0;
      fechaPractica.value = DateTime.now();

      Get.snackbar(
        'Practica creada',
        'Practica creada con exito',
        icon: Icon(Icons.check),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        ModalRoute.withName('/'),
      );
    } catch (e) {
      print(e);
    }
  }

  handleGetCursoAndPracticas(BuildContext context, int id) async {
    try {
      final cursoDB = await HttpMod.get('cursos/$id', {});

      curso = Curso.fromJson(jsonDecode(cursoDB.body)).obs;
      cursoClase = curso.value.cursoClases.first.obs;

      Navigator.pushNamed(
        context,
        '/practicas',
      );
    } catch (e) {
      print(e);
    }
  }

  handleAddAlumno(CursoAlumno alumno) {
    final alumnoFindIndex = cursoAlumnos.value.indexWhere(
      (element) => element.id == alumno.id && element.role == alumno.role,
    );

    if (alumnoFindIndex == -1) {
      cursoAlumnos.add(alumno);

      update();
    }
  }
}
