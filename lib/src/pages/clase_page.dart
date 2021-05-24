import 'package:flutter/material.dart';
import 'package:reproductor/src/components/videopy_component.dart';

class ClasePage extends StatelessWidget {
  // const ClasePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: VideoPlay(
          url:
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        ),
      ),
    );
  }
}
