import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:reproductor/src/models/Clase_model.dart';
import 'package:reproductor/src/pages/clase_page.dart';
import 'package:reproductor/src/utils/Http.dart';

class ClasesPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _clases = useState<List<Clase>>([]);

    void handleGetInitData() async {
      final res = await HttpMod.get('/cursos/1', {});

      if (res.statusCode == 200) {
        List<Clase> data = jsonDecode(res.body)['CursoClases'].map<Clase>((a) {
          return Clase.fromJson(a);
        }).toList();

        _clases.value = data;
      } else {}
    }

    useEffect(() {
      handleGetInitData();
    }, []);

    return ListView(
      padding: EdgeInsets.all(5),
      children: [
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
        tarjetaClase(),
      ],
    );
  }

  Card tarjetaClase() {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Color(0xFF4CAAB1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(
              Icons.ondemand_video,
              color: Color(0xFFBFE3ED),
            ),
            title: Text(
              'Pautas de normalizacion en nuestro pais parte 2',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'Dr. Santana',
              style: TextStyle(
                color: Colors.white60,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text(
                  'VER CLASE',
                  style: TextStyle(
                    color: Color(0xFFBFE3ED),
                  ),
                ),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
