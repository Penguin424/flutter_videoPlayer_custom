import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/controllers/notificaciones_controller.dart';
import 'package:reproductor/src/models/user_chat_model.dart';
import 'package:reproductor/src/pages/Ventas/DetalleFinalVenta_page.dart';
import 'package:reproductor/src/pages/ViewsDocuemnts/imageView_page.dart';
import 'package:reproductor/src/pages/ViewsDocuemnts/pdfView_page.dart';
import 'package:reproductor/src/pages/chat/ChatDetalle_page.dart';
import 'package:reproductor/src/pages/chat/chat_alumnos_page.dart';
import 'package:reproductor/src/pages/clase_page.dart';
import 'package:reproductor/src/pages/cursoDetalle_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/AlumnosPages/alumnoTarea_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/Examen_Page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/detalleTarea_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/examenes_calificaciones_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/resumenTareasAlumno_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/revicionTareas_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/tareaCrear_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/resumenTareasAlumnosDetalle_page.dart';
import 'package:reproductor/src/pages/loading_page.dart';
import 'package:reproductor/src/pages/pagesHome/ProductoDetalle_page.dart';
import 'package:reproductor/src/pages/pagesHome/ShoppingCar_page.dart';
import 'package:reproductor/src/pages/pagesHome/home.dart';
import 'package:reproductor/src/pages/login_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!kIsWeb) {
    AwesomeNotifications().actionStream.listen(
      (action) {
        final userMap = jsonDecode(
          jsonDecode(action.payload!['data'] as String)['usserMessage'],
        );

        final userNoti = UserChatModel.fromJson(
          userMap,
        );

        Navigator.pushNamed(Get.context!, '/chat', arguments: userNoti);
      },
    );

    if (message.notification!.android!.imageUrl != null ||
        message.notification!.android!.imageUrl != '' ||
        message.notification!.apple!.imageUrl != null ||
        message.notification!.apple!.imageUrl != '') {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: message.notification!.title,
          body: message.notification!.body,
          color: Theme.of(Get.context!).colorScheme.primary,
          bigPicture: message.notification!.android!.imageUrl ??
              message.notification!.apple!.imageUrl,
          notificationLayout: NotificationLayout.BigPicture,
          payload: {
            "data": jsonEncode(message.data),
          },
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'asdasdas',
            label: 'Aceptar',
            buttonType: ActionButtonType.KeepOnTop,
          ),
        ],
      );
    } else if (message.notification!.body!.startsWith('https://')) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: message.notification!.title,
          color: Theme.of(Get.context!).colorScheme.primary,
          bigPicture: message.notification!.body,
          notificationLayout: NotificationLayout.BigPicture,
          payload: {
            "data": jsonEncode(message.data),
          },
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'asdasdas',
            label: 'Aceptar',
            buttonType: ActionButtonType.KeepOnTop,
          ),
        ],
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: message.notification!.title,
          body: message.notification!.body,
          color: Theme.of(Get.context!).colorScheme.primary,
          payload: {
            "data": jsonEncode(message.data),
          },
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'asdasdas',
            label: 'Aceptar',
            buttonType: ActionButtonType.KeepOnTop,
          ),
        ],
      );
    }
  }
}

void main() async {
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
        channelKey: 'key1',
        channelName: 'cosbiome escuela',
        channelDescription: 'notificaciones de cosbiome escuela',
        defaultColor: Color(0XFF4CAAB1),
        ledColor: Colors.white,
      )
    ],
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(GlobalController());
    Get.put(NotificacionesContoller());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Escuela Cosbiome',
      initialRoute: "/loading",
      theme: ThemeData(
        // primaryColor: Colors.red,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0XFF4CAAB1),
          onPrimary: Colors.white,
          background: Color(0XFFF5BB62),
          onBackground: Colors.black,
          secondary: Color(0XFFBFE3ED),
          onSecondary: Colors.white,
          error: Colors.black,
          onError: Colors.white,
          surface: Color(0XFF36787D),
          onSurface: Colors.black,
          brightness: Brightness.light,
        ),
      ),
      routes: {
        "/loading": (BuildContext context) => LoadingPage(),
        "/login": (BuildContext context) => LoginPage(),
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
        "/resumenTareasAlumno": (BuildContext context) =>
            ResumenTareasAlumnos(),
        "/resumenTareasAlumno/detalle": (BuildContext context) =>
            ResumenTareasAlumnosDetalle(),
        "/examen": (BuildContext context) => ExamenPage(),
        "/examen/detalle": (BuildContext context) =>
            ExamenesCalificacionesPage(),
        "/chat": (BuildContext context) => ChatAlumnoPage(),
      },
    );
  }
}
