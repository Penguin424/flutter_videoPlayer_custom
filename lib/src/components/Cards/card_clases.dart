import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';

class CardClase extends HookWidget {
  const CardClase({
    Key? key,
    required this.title,
    required this.id,
    required this.maestro,
    required this.url,
    required this.chat,
  }) : super(key: key);

  final String title;
  final int id;
  final String url;
  final String maestro;
  final bool chat;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Color(0xFF4CAAB1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.ondemand_video,
              color: Color(0xFFBFE3ED),
            ),
            title: Text(
              this.title,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              this.maestro,
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
                onPressed: () {
                  Get.find<GlobalController>().onAddClaseId(this.id, this.chat);
                  Navigator.pushNamed(context, '/clase', arguments: {
                    'video': this.url,
                    'titulo': this.title,
                    'id': this.id,
                  });
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
