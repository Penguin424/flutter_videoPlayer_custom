import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:localstorage/localstorage.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/asistenciasToma_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/clases_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/tareas_page.dart';
import 'package:reproductor/src/utils/Http.dart';

class CursoDetallePage extends HookWidget {
  // const ClasesPage({Key key}) : super(key: key);

  final controller = PageController(
    initialPage: 0,
  );
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
    final _pagesBottomBar = useState<List<TabData>>([
      TabData(iconData: Icons.home_work, title: "Tareas"),
      TabData(iconData: Icons.play_circle_filled, title: "Clases"),
      
    ]);
    final _selector = useState<int>(0);
    final _curso = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );

    useEffect(() {
      LocalStorage localStorage = new LocalStorage('localStorage.json');

      if (localStorage.getItem('role') == 'MAESTRO') {
        _pages.value.add(AsistenciasTomaPage(
          titleAppBar: _titleAppBar,
        ));
        _pagesBottomBar.value.add(
          TabData(iconData: Icons.list_alt_rounded, title: "Asistencias"),
        );
      }
    }, []);

    return Scaffold(
      floatingActionButton: HttpMod.localStorage.getItem('role') == 'MAESTRO'
          ? FloatingActionButton.extended(
              label: Text('Agregar Tarea'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/tarea/crear',
                  arguments: {
                    'idCurso': _curso.value['curso'],
                  },
                );
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
      bottomNavigationBar: FancyBottomNavigation(
        tabs: _pagesBottomBar.value,
        onTabChangedListener: (position) {
          print(position);
          _selector.value = position;
          controller.animateToPage(
            position,
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        },
        circleColor: Color(0xFF4CAAB1),
        inactiveIconColor: Color(0xFF4CAAB1),
        initialSelection: _selector.value,
      ),
      body: Container(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: _pages.value,
          onPageChanged: (page) {
            _selector.value = page;
          },
        ),
      ),
    );
  }
}
