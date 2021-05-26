import 'package:flutter/material.dart';
import 'package:reproductor/src/pages/clase_page.dart';
import 'package:reproductor/src/pages/cursoDetalle_page.dart';
import 'package:reproductor/src/pages/home_page.dart';
import 'package:reproductor/src/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => LoginPage(),
        "/home": (BuildContext context) => PageHome(),
        "/clases": (BuildContext context) => CursoDetallePage(),
        "/clase": (BuildContext context) => ClasePage(),
      },
    );
  }
}
