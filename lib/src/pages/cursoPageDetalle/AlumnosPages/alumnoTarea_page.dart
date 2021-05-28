import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart';

class AlumnoTareaPage extends HookWidget {
  // const AlumnoTareaPage({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _archivos = useState<List<MultipartFile>>([]);
    final _comentario = useState<String>('');

    useEffect(() {
      print(_archivos.value);
    }, [_archivos.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text('ENTREGAR TAREA'),
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
                _comentariosForm(_comentario),
                SizedBox(
                  height: 40.0,
                ),
                _createTable(_archivos),
                SizedBox(
                  height: 40.0,
                ),
                _loadFiles(_archivos),
              ],
            ),
          ),
        ),
      ),
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
          Container(
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
            'doc',
            'docx',
            'xls',
            'xlsx',
            'mp4',
          ],
        );

        if (result != null) {
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

          _archivos.value = files;
        } else {
          // User canceled the picker
        }
      },
      child: Text('SUBIR ARCHIVOS'),
    );
  }
}
