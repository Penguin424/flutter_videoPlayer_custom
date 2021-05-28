import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/asistenciasToma_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/clases_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/tareas_page.dart';
import 'package:reproductor/src/utils/Http.dart';

class CursoDetallePage extends HookWidget {
  // const ClasesPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _pages = useState<List<Widget>>([
      ClasesPage(),
      TareasPage(),
    ]);
    final _curso = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );

    useEffect(() {
      if (HttpMod.localStorage.getItem('role') == 'MAESTRO') {
        _pages.value.add(AsistenciasTomaPage());
      }
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(_curso.value['cursoTitulo']),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
      ),
      body: Container(
        child: PageView(children: _pages.value),
      ),
    );
  }
}
