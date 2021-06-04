import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImgViewer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _params = useState<String>(
      ModalRoute.of(context)!.settings.arguments as String,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_params.value.split('/').last),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAAB1),
      ),
      body: Center(
        child: PinchZoom(
          image: Image.network(_params.value),
          zoomedBackgroundColor: Colors.black.withOpacity(0.5),
          resetDuration: const Duration(milliseconds: 100),
          maxScale: 2.5,
          onZoomStart: () {
            print('Start zooming');
          },
          onZoomEnd: () {
            print('Stop zooming');
          },
        ),
      ),
    );
  }
}
