import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:reproductor/src/components/Cards/card_clases.dart';
import 'package:reproductor/src/models/Clase_model.dart';
import 'package:reproductor/src/utils/Http.dart';

class ClasesPage extends HookWidget {
  const ClasesPage({
    required this.titleAppBar,
  }) : super();

  final ValueNotifier<String> titleAppBar;

  @override
  Widget build(BuildContext context) {
    final _clases = useState<List<Clase>>([]);
    final _curso = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );

    void handleGetInitData() async {
      final res = await HttpMod.get('/clases', {
        '_where[0][ClaseCurso.id]': _curso.value['curso'],
      });

      if (res.statusCode == 200) {
        print(jsonDecode(res.body));
        List<Clase> data = jsonDecode(res.body).map<Clase>((a) {
          return Clase.fromJson(a);
        }).toList();

        this.titleAppBar.value = data.last.claseTitulo;
        _clases.value = data;
      } else {}
    }

    useEffect(() {
      handleGetInitData();
    }, []);

    return ListView(
      padding: EdgeInsets.all(5),
      children: _clases.value.length > 0
          ? _clases.value.map((clase) {
              print(clase.id);
              return CardClase(
                title: clase.claseTitulo,
                id: clase.id,
                url: clase.claseVideo,
                maestro: clase.clasemaestro.username,
                chat: clase.claseActiva,
              );
            }).toList()
          : [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
    );
  }
}
