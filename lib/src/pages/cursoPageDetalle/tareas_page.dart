import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TareasPage extends HookWidget {
  // const TareasPage({}) : super();

  @override
  Widget build(BuildContext context) {
    final _curso = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );
    return Center(
      child: Text('TAREAS DEL CURSO'),
    );
  }
}
