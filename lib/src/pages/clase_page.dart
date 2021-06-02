import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reproductor/src/components/videopy_component.dart';

class ClasePage extends HookWidget {
  // const ClasePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final params = useState<Map<String, dynamic>>(
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);

    useEffect(() {
      print(params.value['video']);
    }, [params.value]);

    return SafeArea(
      child: Scaffold(
        body: VideoPlay(
          url: 'http://192.168.15.157:8000/live/prueba.flv',
          title: params.value['titulo'],
        ),
      ),
    );
  }
}
