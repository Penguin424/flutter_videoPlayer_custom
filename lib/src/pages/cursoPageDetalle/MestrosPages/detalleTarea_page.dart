import 'dart:convert';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:universal_html/html.dart' as html;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reproductor/src/models/DetalleTareas_model.dart';

class DetalleTareaPage extends HookWidget {
  // const DetalleTareaPage({Key key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _tareaDetalle = useState<DetalleTareas>(
      ModalRoute.of(context)!.settings.arguments as DetalleTareas,
    );
    final _porcentajeTotal = useState(0);
    final _totalArchivo = useState(0);
    final _calificacion = useState<TextEditingController>(
      TextEditingController(
        text: _tareaDetalle.value.tareaDetCalificacion.toString(),
      ),
    );
    final _isLoading = useState<bool>(false);
    final _modalCal = useState<bool>(true);

    useEffect(() {
      print(_tareaDetalle.value);
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text('CALIFICAR TAREA'),
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
                children: [
                  _comentariosForm(_tareaDetalle),
                  SizedBox(
                    height: 40.0,
                  ),
                  _createTable(
                    _tareaDetalle,
                    _totalArchivo,
                    _porcentajeTotal,
                    _isLoading,
                    context,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  _createCalificacion(_calificacion, _tareaDetalle),
                  SizedBox(
                    height: 50.0,
                  ),
                  _createButtonsCalReg(
                    _tareaDetalle,
                    _isLoading,
                    _modalCal,
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

  Row _createButtonsCalReg(
    ValueNotifier<DetalleTareas> _tareaDetalle,
    ValueNotifier<bool> _isLoading,
    ValueNotifier<bool> _modalCal,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () async {
            _modalCal.value = false;
            final id = _tareaDetalle.value.id;
            _isLoading.value = true;
            await HttpMod.update(
              '/detalletareas/$id',
              jsonEncode(
                {
                  'TareaDetCalificacion':
                      _tareaDetalle.value.tareaDetCalificacion,
                },
              ),
            );
            _isLoading.value = false;
            Navigator.pop(context);
          },
          child: Text('CALIFICAR'),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF4CAAB1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            _modalCal.value = false;
            final id = _tareaDetalle.value.id;
            _isLoading.value = true;
            await HttpMod.delete(
              '/detalletareas/$id',
            );
            _isLoading.value = false;
            Navigator.pop(context);
          },
          child: Text('REGRESAR'),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }

  TextField _createCalificacion(
    ValueNotifier<TextEditingController> _calificacion,
    ValueNotifier<DetalleTareas> _tareaDetalle,
  ) {
    return TextField(
      controller: _calificacion.value,
      onChanged: (String value) {
        _tareaDetalle.value.tareaDetCalificacion = int.parse(value);
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: '0/100',
        labelText: 'CALIFICACION TAREA',
        labelStyle: TextStyle(
          color: Color(0xFF4CAAB1),
        ),
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
      ),
      cursorColor: Color(0xFF4CAAB1),
    );
  }

  TextFormField _comentariosForm(ValueNotifier<DetalleTareas> _tareaDetalle) {
    return TextFormField(
      initialValue: _tareaDetalle.value.tareaDetDescripcion,
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
    );
  }

  Widget _createTable(
    ValueNotifier<DetalleTareas> _tareaDetalle,
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
        ..._generadorProducto(
          _tareaDetalle.value.tareaDetArchivo.split(',').toList(),
          _totalArchivo,
          _porcentajeTotal,
          _isLoading,
          context,
        ),
      ],
    );
  }

  List<TableRow> _generadorProducto(
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
      Dio dio = Dio();

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
}
