import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reproductor/src/models/DetalleTareas_model.dart';

class DetalleTareaPage extends HookWidget {
  // const DetalleTareaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _tareaDetalle = useState<DetalleTareas>(
    //   ModalRoute.of(context)!.settings.arguments as DetalleTareas,
    // );
    final _porcentajeTotal = useState(0);
    final _totalArchivo = useState(0);

    // useEffect(() {
    //   print(_tareaDetalle.value);
    // }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text('CALIFICAR TAREA'),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('progreso: ${_porcentajeTotal.value}'),
                SizedBox(
                  width: 50.0,
                ),
                Text('total: ${_totalArchivo.value}'),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              child: Text('DESCARGAR ARCHIVO'),
              onPressed: () =>
                  handleGetArchive(_totalArchivo, _porcentajeTotal),
            ),
          ],
        ),
      ),
    );
  }

  void handleGetArchive(
    ValueNotifier<int> _totalArchivo,
    ValueNotifier<int> _porcentajeTotal,
  ) async {
    if (kIsWeb) {
      html.window.open(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        'new tab',
      );
    } else {
      Dio dio = Dio();

      try {
        final dir = await getDownloadsDirectory();
        final res = await dio.download(
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          '${dir!.path}/file',
          onReceiveProgress: (prog, tot) {
            _porcentajeTotal.value = tot;
            _totalArchivo.value = prog;
          },
        );

        print(res);
      } catch (e) {}
    }
  }
}
