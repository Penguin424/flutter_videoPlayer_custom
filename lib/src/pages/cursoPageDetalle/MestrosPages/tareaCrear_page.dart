import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TareaCrear extends HookWidget {
  // const TareaCrear({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AGREGAR TAREA'),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
      ),
    );
  }
}
