import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// import 'package:reproductor/src/components/navigation_component.dart';
import 'package:reproductor/src/models/Curso.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class PageHome extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _cursosAlumnos = useState<List<Curso>>([]);
    void initGetDate() async {
      try {
        final id = PreferenceUtils.getString('idUser');

        final res = await HttpMod.get(
          '/cursos',
          {
            '_where[0][CursoAlumnos.id]': id.toString(),
          },
        );

        print('/cursos/_where[0][CursoAlumnos.id]=${id.toString()}');
        print(res);

        if (res.statusCode == 200) {
          List<Curso> data = jsonDecode(res.body).map<Curso>((a) {
            return Curso.fromJson(a);
          }).toList();

          _cursosAlumnos.value = data;

          print('Cursos: ${_cursosAlumnos.value}');
        }
      } catch (e) {}
    }

    useEffect(() {
      initGetDate();
    }, []);

    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(5),
          children: _cursosAlumnos.value.length > 0
              ? _cursosAlumnos.value.map((e) {
                  return card(
                    context,
                    e.cursoTitulo,
                    e.id,
                    e.cursoClases.last,
                    e.cursoClases.length,
                  );
                }).toList()
              : [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
        ),
      ),
    );
  }

  GestureDetector card(
    BuildContext context,
    String title,
    int curso,
    CursoClase claseCurso,
    int clasesTotal,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/clases',
          arguments: {
            'curso': curso.toString(),
            'cursoTitulo': title,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF4CAAB1),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF36787D),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        margin: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              title.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
              ),
              maxLines: 2,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    'CLASES COMPLETADAS $clasesTotal/12',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    claseCurso.claseTitulo,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CONTINUAR CLASE',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.chevron_right_sharp,
                  size: 32,
                  color: Color(0xFFBFE3ED),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
