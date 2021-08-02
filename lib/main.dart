import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/pages/ViewsDocuemnts/imageView_page.dart';
import 'package:reproductor/src/pages/ViewsDocuemnts/pdfView_page.dart';
import 'package:reproductor/src/pages/clase_page.dart';
import 'package:reproductor/src/pages/cursoDetalle_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/AlumnosPages/alumnoTarea_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/detalleTarea_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/revicionTareas_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/tareaCrear_page.dart';
import 'package:reproductor/src/pages/pagesHome/ProductoDetalle_page.dart';
import 'package:reproductor/src/pages/pagesHome/ShoppingCar_page.dart';
import 'package:reproductor/src/pages/pagesHome/home.dart';
import 'package:reproductor/src/pages/pagesHome/home_pageCursos.dart';
import 'package:reproductor/src/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(GlobalController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => LoginPage(),
        "/home": (BuildContext context) => HomeApp(),
        "/clases": (BuildContext context) => CursoDetallePage(),
        "/clase": (BuildContext context) => ClasePage(),
        "/entregaTarea": (BuildContext context) => AlumnoTareaPage(),
        "/tarea/crear": (BuildContext context) => TareaCrear(),
        "/tarea/calificar": (BuildContext context) => DetalleTareaPage(),
        "/tareas": (BuildContext context) => RevisionTareas(),
        "/readers/pdf": (BuildContext context) => PdfViewPage(),
        "/readers/img": (BuildContext context) => ImgViewer(),
        '/detalleProducto': (BuildContext context) => ProductoDetalle(),
        '/shoppingCar': (BuildContext context) => ShoppingCar(),
      },
    );
  }
}
