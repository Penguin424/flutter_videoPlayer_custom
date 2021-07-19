import 'dart:convert';

import 'package:dio/dio.dart' as dioo;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:reproductor/src/models/Tarea.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import 'package:reproductor/src/utils/Http.dart';

class AlumnoTareaPage extends HookWidget {
  // const AlumnoTareaPage({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _archivos = useState<List<MultipartFile>>([]);
    final _comentario = useState<String>('');
    final _params = useState<Map<String, dynamic>>(
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
    );
    final _archivosTarea = useState<String>('');
    final _isLoading = useState<bool>(false);
    final _modalCal = useState<bool>(true);
    final _porcentajeTotal = useState(0);
    final _totalArchivo = useState(0);
    final _tituloTarea = useState<String>('TAREA');

    void handleGetInitData() async {
      final res = await HttpMod.get(
        'tareas/${_params.value['idTarea']}',
        {},
      );

      if (res.statusCode == 200) {
        Tarea tarea = Tarea.fromJson(jsonDecode(res.body));

        _archivosTarea.value = tarea.tareaArchivo;
        _tituloTarea.value = tarea.tareaNombre;
      }
    }

    useEffect(() {
      handleGetInitData();
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloTarea.value),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
      ),
      body: LoadingOverlay(
        progressIndicator: _modalCal.value
            ? _modalCompleto(_porcentajeTotal, _totalArchivo)
            : CircularProgressIndicator(),
        isLoading: _isLoading.value,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _comentariosForm(_comentario),
                  SizedBox(
                    height: 40.0,
                  ),
                  _createTableLinks(
                    _archivosTarea,
                    _totalArchivo,
                    _porcentajeTotal,
                    _isLoading,
                    context,
                  ),
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
                    context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _modalCompleto(
    ValueNotifier<int> _porcentajeTotal,
    ValueNotifier<int> _totalArchivo,
  ) {
    return Container(
      height: 100,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: _modalDescarga(
        _porcentajeTotal,
        _totalArchivo,
      ),
    );
  }

  Center _modalDescarga(
    ValueNotifier<int> _porcentajeTotal,
    ValueNotifier<int> _totalArchivo,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('DESCARGANDO'),
          Text('${_porcentajeTotal.value}% / ${_totalArchivo.value} MB'),
        ],
      ),
    );
  }

  ElevatedButton _updloadAndSendTask(
    ValueNotifier<List<MultipartFile>> _archivos,
    ValueNotifier<String> _comentario,
    ValueNotifier<Map<String, dynamic>> _params,
    BuildContext context,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF01DF3A),
      ),
      child: Text('ENTREGAR TAREA'),
      onPressed: () async {
        try {
          List<String> archs = [];

          for (MultipartFile file in _archivos.value) {
            String url = 'https://cosbiomeescuela.s3.us-east-2.amazonaws.com/';
            MultipartRequest request = MultipartRequest('POST', Uri.parse(url));
            request.files.add(file);

            request.fields.addAll({
              'key': file.filename!,
            });
            StreamedResponse resa = await request.send();

            archs.add('${resa.request!.url.origin}/${file.filename!}');
          }

          HttpMod.post(
            'detalletareas',
            jsonEncode(
              {
                'tareaDetDescripcion': _comentario.value,
                'tareaDetArchivo': archs.join(','),
                'tareaDetEntrega': DateTime.now().toString(),
                'tareaDetCalificacion': 0.0,
                'tareaDetAlumno': HttpMod.localStorage.getItem('idUser'),
                'tareaDetTarea': _params.value['idTarea'] as int,
                'tareaDetEntregada': 1,
              },
            ),
          );

          Navigator.pop(context);
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

  Widget _createTableLinks(
    // ValueNotifier<Tarea> _tarea,
    ValueNotifier<String> _archivosTarea,
    ValueNotifier<int> _totalArchivo,
    ValueNotifier<int> _porcentajeTotal,
    ValueNotifier<bool> _isLoading,
    BuildContext context,
  ) {
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
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
            Center(
              child: Container(
                color: Color.fromRGBO(76, 170, 177, 0.8),
                height: 48,
                child: Center(
                  child: Text(
                    'VER',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        ..._generadorProductoLinks(
          _archivosTarea.value.split(',').toList(),
          _totalArchivo,
          _porcentajeTotal,
          _isLoading,
          context,
        ),
      ],
    );
  }

  List<TableRow> _generadorProductoLinks(
    List<String> archivoss,
    ValueNotifier<int> _totalArchivo,
    ValueNotifier<int> _porcentajeTotal,
    ValueNotifier<bool> _isLoading,
    BuildContext context,
  ) {
    if (archivoss.length <= 0) return [];

    final List<TableRow> archivos = archivoss.map<TableRow>((a) {
      // String megas = (a.length / 100000).toStringAsFixed(2);

      return TableRow(
        children: [
          Container(
            color: Color.fromRGBO(76, 170, 177, 0.1),
            height: 48,
            child: Center(
              child: Text(
                a.split('/').last,
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
                    'VER',
                    style: TextStyle(fontSize: 10.0),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF4CAAB1),
                ),
                onPressed: () => _showDialog(
                  context,
                  _porcentajeTotal,
                  _totalArchivo,
                  _isLoading,
                  a.split('/').last.split('.').last,
                  a,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();

    return archivos;
  }

  Future<void> _showDialog(
    BuildContext context,
    ValueNotifier<int> _totalArchivo,
    ValueNotifier<int> _porcentajeTotal,
    ValueNotifier<bool> _isLoading,
    String ext,
    String url,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('OPCION DE VISULIZACION'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text('CANCELAR'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('DESCARGAR'),
                  onPressed: () {
                    Navigator.pop(context);
                    handleGetArchive(
                      context,
                      _totalArchivo,
                      _porcentajeTotal,
                      _isLoading,
                      url,
                    );
                  },
                ),
                TextButton(
                  child: Text('VER'),
                  onPressed: () {
                    if (kIsWeb) {
                      handleGetArchive(
                        context,
                        _totalArchivo,
                        _porcentajeTotal,
                        _isLoading,
                        url,
                      );
                    } else {
                      if (ext == 'mp4') {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/clase',
                          arguments: {
                            'video': url,
                            'titulo': url.split('/').last,
                          },
                        );
                      } else if (ext == 'pdf') {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/readers/pdf',
                          arguments: url,
                        );
                      } else if (ext == 'jpg' || ext == 'png') {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/readers/img',
                          arguments: url,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void handleGetArchive(
    BuildContext context,
    ValueNotifier<int> _totalArchivo,
    ValueNotifier<int> _porcentajeTotal,
    ValueNotifier<bool> _isLoading,
    String url,
  ) async {
    if (kIsWeb) {
      html.window.open(
        url,
        'new tab',
      );
    } else {
      dioo.Dio dio = dioo.Dio();

      final nameVideo = url.split('/').last;

      try {
        _isLoading.value = true;
        final dir = await getExternalStorageDirectory();
        await dio.download(
          url,
          '${dir!.path}/$nameVideo',
          onReceiveProgress: (prog, tot) {
            _porcentajeTotal.value = tot ~/ 1000000;
            _totalArchivo.value = ((prog / tot) * 100).toInt();

            print('sad');
          },
        );
        _isLoading.value = false;
      } catch (e) {
        print(e);
      }
    }
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
            'doc',
            'docx',
            'xls',
            'xlsx',
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
