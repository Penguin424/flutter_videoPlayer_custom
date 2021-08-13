import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/pages/Ventas/DetalleFinalVenta_page.dart';
import 'package:reproductor/src/pages/ViewsDocuemnts/imageView_page.dart';
import 'package:reproductor/src/pages/ViewsDocuemnts/pdfView_page.dart';
import 'package:reproductor/src/pages/chat/ChatDetalle_page.dart';
import 'package:reproductor/src/pages/clase_page.dart';
import 'package:reproductor/src/pages/cursoDetalle_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/AlumnosPages/alumnoTarea_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/detalleTarea_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/revicionTareas_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/tareaCrear_page.dart';
import 'package:reproductor/src/pages/pagesHome/ProductoDetalle_page.dart';
import 'package:reproductor/src/pages/pagesHome/ShoppingCar_page.dart';
import 'package:reproductor/src/pages/pagesHome/home.dart';
import 'package:reproductor/src/pages/login_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
        channelKey: 'key1',
        channelName: 'cosbiome escuela',
        channelDescription: 'notificaciones de cosbiome escuela',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
  );
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(GlobalController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Escuela Cosbiome',
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
        '/detalleVentaMandar': (BuildContext context) => VentaSendVendedor(),
        '/detalleChat': (BuildContext context) => ChatDetalle(),
      },
    );
  }
}
