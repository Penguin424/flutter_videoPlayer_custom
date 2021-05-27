import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/clases_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/tareas_page.dart';

class CursoDetallePage extends HookWidget {
  // const ClasesPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clases del curso'),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
      ),
      body: PageView(
        children: [
          ClasesPage(),
          TareasPage(),
        ],
      ),
    );
  }
}
