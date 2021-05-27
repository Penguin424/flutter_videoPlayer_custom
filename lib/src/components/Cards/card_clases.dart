import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CardClase extends HookWidget {
  const CardClase({
    Key? key,
    required this.title,
    required this.id,
    required this.maestro,
    required this.url,
  }) : super(key: key);

  final String title;
  final int id;
  final String url;
  final String maestro;

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
                  Navigator.pushNamed(context, '/clase', arguments: {
                    'video': this.url,
                    'titulo': this.title,
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
