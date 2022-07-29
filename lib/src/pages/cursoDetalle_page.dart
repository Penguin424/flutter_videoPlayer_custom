import 'dart:convert';

import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/instance_manager.dart';
import 'package:localstorage/localstorage.dart';
import 'package:reproductor/src/controllers/practicas_controller.dart';
import 'package:reproductor/src/models/termario_model.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/AlumnosPages/progreso_alumnos_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/Examenes_Page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/MestrosPages/asistenciasToma_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/clases_page.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/tareas_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class CursoDetallePage extends HookWidget {
  // const ClasesPage({Key key}) : super(key: key);

  final controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    final practicas = Get.find<PracticasController>();
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
      TabData(iconData: Icons.play_circle_filled, title: "Clases"),
      TabData(iconData: Icons.home_work, title: "Tareas"),
    ]);
    final _selector = useState<int>(0);
    final _curso = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );

    useEffect(() {
      if (PreferenceUtils.getString('role') == 'MAESTRO') {
        _pages.value.add(AsistenciasTomaPage(
          titleAppBar: _titleAppBar,
        ));
        _pagesBottomBar.value.add(
          TabData(iconData: Icons.list_alt_rounded, title: "Asistencias"),
        );
      }

      // if (PreferenceUtils.getString('role') == 'ALUMNO') {
      _pages.value.add(
        ExamenesCurso(
          idCurso: int.parse(_curso.value['curso']),
          titleAppBar: _titleAppBar,
        ),
      );
      _pagesBottomBar.value.add(
        TabData(iconData: Icons.quiz, title: "Examenes"),
      );

      if (PreferenceUtils.getString('role') == 'ALUMNO') {
        _pages.value.add(ProgresoAlumnosPage(
          idCurso: int.parse(_curso.value['curso']),
          titleAppBar: _titleAppBar,
        ));
        _pagesBottomBar.value.add(
          TabData(iconData: Icons.bar_chart_rounded, title: "Progreso"),
        );
      }
      // }
    }, []);

    return Scaffold(
      floatingActionButton: PreferenceUtils.getString('role') == 'MAESTRO'
          ? _getFAB(
              context,
              _curso,
              practicas,
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(_titleAppBar.value),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
        actions: [
          // IconButton(
          //     onPressed: () async {
          //       late List<TermarioModel> temario;
          //       String titulocurso = _curso.value['cursoTitulo'];

          //       if (titulocurso.toLowerCase().contains('cosmetologia')) {
          //         String data =
          //             await rootBundle.loadString('assets/cosmetologia.json');

          //         temario = jsonDecode(data).map<TermarioModel>((e) {
          //           return TermarioModel.fromJson(e);
          //         }).toList();
          //       }

          //       if (titulocurso.toLowerCase().contains('cosmiatria')) {
          //         String data =
          //             await rootBundle.loadString('assets/cosmiatria.json');

          //         temario = jsonDecode(data).map<TermarioModel>((e) {
          //           return TermarioModel.fromJson(e);
          //         }).toList();
          //       }

          //       return showDialog(
          //         context: context,
          //         builder: (context) {
          //           return AlertDialog(
          //             title: Text(
          //               'TEMARIO',
          //               textAlign: TextAlign.center,
          //             ),
          //             content: Container(
          //               height: MediaQuery.of(context).size.height * 0.5,
          //               width: MediaQuery.of(context).size.width * 0.8,
          //               child: ListView.separated(
          //                 separatorBuilder: (context, index) => Divider(
          //                   color: Colors.black,
          //                 ),
          //                 itemCount: temario.length,
          //                 itemBuilder: (context, index) {
          //                   return ListTile(
          //                       title: Text(
          //                         temario[index].modulo!,
          //                         style: TextStyle(
          //                           fontSize: 20,
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                         textAlign: TextAlign.center,
          //                       ),
          //                       subtitle: Column(
          //                         children: temario[index].clases!.map((e) {
          //                           return Container(
          //                             margin: EdgeInsets.only(
          //                               top: 10,
          //                             ),
          //                             child: ListTile(
          //                               title: Text(
          //                                 e!,
          //                                 style: TextStyle(
          //                                   fontSize: 15,
          //                                   fontWeight: FontWeight.bold,
          //                                 ),
          //                                 textAlign: TextAlign.center,
          //                               ),
          //                             ),
          //                           );
          //                         }).toList(),
          //                       ));
          //                 },
          //               ),
          //             ),
          //           );
          //         },
          //       );
          //     },
          //     icon: Icon(Icons.view_list)),
        ],
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

  Widget _getFAB(
      BuildContext context,
      ValueNotifier<Map<String, dynamic>> _curso,
      PracticasController practicas) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Color(0xFF4CAAB1),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
          child: Icon(
            Icons.post_add_rounded,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF4CAAB1),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/tarea/crear',
              arguments: {
                'idCurso': _curso.value['curso'],
              },
            );
          },
          label: 'Agregar Tarea',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),
          labelBackgroundColor: Color(0xFF4CAAB1),
        ),
        // FAB 2
        SpeedDialChild(
          child: Icon(
            Icons.person_rounded,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF4CAAB1),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/resumenTareasAlumno',
              arguments: {
                'idCurso': _curso.value['curso'],
              },
            );
          },
          label: 'Resumen Tareas Alumnos',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 10.0,
          ),
          labelBackgroundColor: Color(0xFF4CAAB1),
        ),
        // FAB 3
        SpeedDialChild(
          child: Icon(
            Icons.quiz_rounded,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF4CAAB1),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/examen/crear',
              arguments: {
                'idCurso': _curso.value['curso'],
              },
            );
          },
          label: 'Crear Examen',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 10.0,
          ),
          labelBackgroundColor: Color(0xFF4CAAB1),
        ),
        // FAB 4
        SpeedDialChild(
          child: Icon(
            Icons.list_alt_rounded,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF4CAAB1),
          onTap: () {
            // Navigator.pushNamed(
            //   context,
            //   '/practicas',
            //   arguments: {
            //     'idCurso': _curso.value['curso'],
            //   },
            // );
            practicas.handleGetCursoAndPracticas(
              context,
              int.parse(_curso.value['curso'].toString()),
            );
          },
          label: 'Practicas',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 10.0,
          ),
          labelBackgroundColor: Color(0xFF4CAAB1),
        ),
        // FAB 5
        SpeedDialChild(
          child: Icon(
            Icons.assignment_turned_in_rounded,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF4CAAB1),
          onTap: () {
            String titulocurso = _curso.value['cursoTitulo'];

            Navigator.pushNamed(
              context,
              '/readers/pdf',
              arguments: titulocurso.toLowerCase().contains('cosmiatria')
                  ? 'https://cosbiomeescuela.s3.us-east-2.amazonaws.com/avancesprogramaticos/avance+programatico+cosmiatria.pdf'
                  : 'https://cosbiomeescuela.s3.us-east-2.amazonaws.com/avancesprogramaticos/avance+programatico+cosmetologia.pdf',
            );
          },
          label: 'Avance programatico',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 10.0,
          ),
          labelBackgroundColor: Color(0xFF4CAAB1),
        ),
      ],
    );
  }
}
