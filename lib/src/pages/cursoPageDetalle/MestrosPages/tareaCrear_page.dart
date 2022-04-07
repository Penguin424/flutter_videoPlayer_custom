import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart';
import 'package:reproductor/src/models/Clase_model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class TareaCrear extends HookWidget {
  // const AlumnoTareaPage({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _archivos = useState<List<MultipartFile>>([]);
    final _comentario = useState<String>('');
    final _tareaNombre = useState<String>('');
    final _puntos = useState<int>(1);
    final _clases = useState<List<Clase>>([]);
    final _claseSelect = useState<int>(0);
    final _params = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );

    void handleGetInitData() async {
      final res = await HttpMod.get('/clases', {
        '_where[0][ClaseCurso.id]': _params.value['idCurso'],
      });

      if (res.statusCode == 200) {
        List<Clase> data = jsonDecode(res.body).map<Clase>((a) {
          return Clase.fromJson(a);
        }).toList();

        _claseSelect.value = data.first.id;
        _clases.value = data;
      }
    }

    useEffect(() {
      handleGetInitData();
    }, [_archivos.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text('CREAR TAREA'),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _clasesListas(_clases, _claseSelect),
                SizedBox(
                  height: 40.0,
                ),
                _nombreTareaText(_tareaNombre),
                SizedBox(
                  height: 40.0,
                ),
                _comentariosForm(_comentario),
                SizedBox(
                  height: 40.0,
                ),
                _puntosTarea(_puntos),
                SizedBox(
                  height: 40.0,
                ),
                _createTable(_archivos),
                SizedBox(
                  height: 40.0,
                ),
                _loadFiles(_archivos),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4.5,
                ),
                _updloadAndSendTask(
                  _archivos,
                  _comentario,
                  _params,
                  _puntos,
                  _claseSelect,
                  _tareaNombre,
                  context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _nombreTareaText(ValueNotifier<String> _tareaNombre) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'TAREA NOMBRE',
        focusColor: Color(0xFF4CAAB1),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF4CAAB1),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF4CAAB1),
          ),
        ),
        labelStyle: TextStyle(
          color: Color(0xFF4CAAB1),
        ),
      ),
      onChanged: (value) => _tareaNombre.value = value,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Debe ingresar un nombre para la tarea';
        }
      },
    );
  }

  TextFormField _puntosTarea(ValueNotifier<int> _puntos) {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Debe ingresar un número de puntos de la tarea';
        }
      },
      decoration: InputDecoration(
        labelText: 'PUNTOS DE LA TAREA',
        focusColor: Color(0xFF4CAAB1),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF4CAAB1),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF4CAAB1),
          ),
        ),
        labelStyle: TextStyle(
          color: Color(0xFF4CAAB1),
        ),
      ),
      onChanged: (value) => _puntos.value = int.parse(value),
    );
  }

  DropdownButton<int> _clasesListas(
      ValueNotifier<List<Clase>> _clases, ValueNotifier<int> _claseSelect) {
    return DropdownButton<int>(
      icon: Icon(Icons.arrow_downward),
      value: _claseSelect.value,
      isExpanded: true,
      items: _clases.value.length > 0
          ? _clases.value.map((e) {
              return DropdownMenuItem<int>(
                value: e.id,
                child: Center(
                  child: Text(e.claseTitulo),
                ),
              );
            }).toList()
          : [
              DropdownMenuItem<int>(
                value: 0,
                child: Center(
                  child: Text('CLASE'),
                ),
              )
            ],
      onChanged: (int? value) {
        _claseSelect.value = value ?? 0;
      },
    );
  }

  ElevatedButton _updloadAndSendTask(
    ValueNotifier<List<MultipartFile>> _archivos,
    ValueNotifier<String> _comentario,
    ValueNotifier<Map<String, dynamic>> _params,
    ValueNotifier<int> _puntos,
    ValueNotifier<int> _claseSelect,
    ValueNotifier<String> _tareaNombre,
    BuildContext context,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF01DF3A),
      ),
      child: Text('ENTREGAR TAREA'),
      onPressed: () async {
        try {
          if (_formKey.currentState!.validate()) {
            List<String> archs = [];

            for (MultipartFile file in _archivos.value) {
              // String url =
              //     'https://cosbiomeescuela.s3.us-east-2.amazonaws.com/';
              // MultipartRequest request =
              //     MultipartRequest('POST', Uri.parse(url));
              // request.files.add(file);

              // request.fields.addAll({
              //   'key': file.filename!,
              // });
              // StreamedResponse resa = await request.send();

              // archs.add('${resa.request!.url.origin}/${file.filename!}');

              final urlFileAlumno = await HttpMod.loadFileAlumno(file);
              archs.add(urlFileAlumno);
            }

            // tareaDescripcion
            // tareaArchivo
            // tareaEntrega
            // tareaPuntos
            // tareaMaestro
            // tareaCurso
            // tareaClase
            // tareaActiva

            HttpMod.post(
              'tareas',
              jsonEncode(
                {
                  'tareaDescripcion': _comentario.value,
                  'tareaArchivo': archs.join(','),
                  'tareaNombre': _tareaNombre.value,
                  'tareaEntrega': DateTime.now().toString(),
                  'tareaPuntos': _puntos.value,
                  'tareaMaestro':
                      int.parse(PreferenceUtils.getString('idUser')),
                  'tareaCurso': int.parse(_params.value['idCurso']),
                  'tareaClase': _claseSelect.value,
                  'tareaActiva': 1,
                },
              ),
            );

            Navigator.pop(context);
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }

  Widget _createTable(
    ValueNotifier<List<MultipartFile>> _archivos,
  ) {
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(children: <Widget>[
          Container(
            color: Color.fromRGBO(76, 170, 177, 0.8),
            height: 48,
            child: Center(
              child: Text(
                'NOMBRE DE ARCHIVO',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            color: Color.fromRGBO(76, 170, 177, 0.8),
            height: 48,
            child: Center(
              child: Text(
                'PESO DE ARCHIVO',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              color: Color.fromRGBO(76, 170, 177, 0.8),
              height: 48,
              child: Center(
                child: Text(
                  'ELIMINAR',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ]),
        ..._generadorProducto(_archivos),
      ],
    );
  }

  List<TableRow> _generadorProducto(
    ValueNotifier<List<MultipartFile>> _archivos,
  ) {
    if (_archivos.value.length <= 0) return [];

    final List<TableRow> archivos = _archivos.value.map<TableRow>((a) {
      String megas = (a.length / 100000).toStringAsFixed(2);

      return TableRow(
        children: [
          Container(
            color: Color.fromRGBO(76, 170, 177, 0.1),
            height: 48,
            child: Center(
              child: Text(
                a.filename.toString(),
                style: TextStyle(fontSize: 10.0),
              ),
            ),
          ),
          Container(
            color: Color.fromRGBO(76, 170, 177, 0.1),
            height: 48,
            child: Center(
              child: Text(
                '$megas MB',
                style: TextStyle(fontSize: 10.0),
              ),
            ),
          ),
          Container(
            color: Color.fromRGBO(76, 170, 177, 0.1),
            height: 48,
            child: Center(
              child: ElevatedButton(
                child: Container(
                  child: Text(
                    'ELIMINAR',
                    style: TextStyle(fontSize: 10.0),
                  ),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  _archivos.value = _archivos.value
                      .where((element) => element.filename != a.filename)
                      .toList();
                },
              ),
            ),
          ),
        ],
      );
    }).toList();

    return archivos;
  }

  TextFormField _comentariosForm(ValueNotifier<String> _comentario) {
    return TextFormField(
      style: TextStyle(),
      maxLines: 8,
      decoration: InputDecoration(
        labelText: 'COMENTARIO DE LA TAREA',
        focusColor: Color(0xFF4CAAB1),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF4CAAB1),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF4CAAB1),
          ),
        ),
        labelStyle: TextStyle(
          color: Color(0xFF4CAAB1),
        ),
      ),
      onChanged: (value) {
        _comentario.value = value;
      },
    );
  }

  ElevatedButton _loadFiles(ValueNotifier<List<MultipartFile>> _archivos) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF4CAAB1),
      ),
      onPressed: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: true,
          allowedExtensions: [
            'jpg',
            'pdf',
            'mp4',
          ],
        );

        if (result != null) {
          if (kIsWeb) {
            List<Map<String, dynamic>> data = result.files.map((e) {
              return {
                'bytes': e.bytes!.toList(),
                'name': e.name,
              };
            }).toList();

            List<MultipartFile> files = data.map((e) {
              return MultipartFile.fromBytes(
                'file',
                e['bytes'],
                filename: e['name'],
              );
            }).toList();

            print(files);

            _archivos.value = files;
          } else {
            List<Map<String, dynamic>> data = result.files.map((e) {
              return {
                'bytes': e.path,
                'name': e.name,
              };
            }).toList();

            List<Future<MultipartFile>> files = data.map((e) async {
              return await MultipartFile.fromPath(
                'file',
                e['bytes'],
                filename: e['name'],
              );
            }).toList();

            List<MultipartFile> filesArr = [];

            files.forEach((element) {
              element.then((value) {
                filesArr.add(value);
              });
            });

            _archivos.value = filesArr;
          }
        } else {
          // User canceled the picker
        }
      },
      child: Text('SUBIR ARCHIVOS'),
    );
  }
}
