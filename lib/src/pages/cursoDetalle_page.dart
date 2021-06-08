import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:localstorage/localstorage.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/asistenciasToma_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/clases_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/tareas_page.dart';
import 'package:reproductor/src/utils/Http.dart';

class CursoDetallePage extends HookWidget {
  // const ClasesPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _titleAppBar = useState<String>('CURSO');
    final _pages = useState<List<Widget>>([
      ClasesPage(
        titleAppBar: _titleAppBar,
      ),
      TareasPage(
        titleAppBar: _titleAppBar,
      ),
    ]);
    final _curso = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );

    useEffect(() {
      LocalStorage localStorage = new LocalStorage('localStorage.json');

      print(localStorage.getItem('role'));

      if (localStorage.getItem('role') == 'MAESTRO') {
        _pages.value.add(AsistenciasTomaPage(
          titleAppBar: _titleAppBar,
        ));
      }
    }, []);

    return Scaffold(
      floatingActionButton: HttpMod.localStorage.getItem('role') == 'MAESTRO'
          ? FloatingActionButton.extended(
              label: Text('Agregar Tarea'),
              onPressed: () {
                Navigator.pushNamed(context, '/tarea/crear');
              },
              backgroundColor: Color(0xFF4CAAB1),
              icon: Icon(
                Icons.post_add_rounded,
              ),
            )
          : Container(),
      appBar: AppBar(
        title: Text(_titleAppBar.value),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
      ),
      body: Container(
        child: PageView(children: _pages.value),
      ),
    );
  }
}
