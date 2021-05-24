import 'package:flutter/material.dart';
import 'package:reproductor/src/pages/clase_page.dart';
import 'package:reproductor/src/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => PageHome(),
        "/clase": (BuildContext context) => ClasePage(),
      },
    );
  }
}
