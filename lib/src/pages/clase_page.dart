import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reproductor/src/components/VideoPlayFull.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:get/get.dart';
import 'package:universal_platform/universal_platform.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ClasePage extends StatefulWidget {
  ClasePage({Key? key}) : super(key: key);

  @override
  _ClasePageState createState() => _ClasePageState();
}

class _ClasePageState extends State<ClasePage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final params =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: GetBuilder<GlobalController>(builder: (_) {
        return Container(
          color: UniversalPlatform.isIOS ? Colors.black : Colors.white,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: _.fullScreen
                  ? NeverScrollableScrollPhysics()
                  : ScrollPhysics(),
              child: Column(
                children: [
                  VideoPlayerFull(
                    url: params['video'],
                    title: params['titulo'],
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Center(
                      child: Text(
                        params['titulo'],
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
