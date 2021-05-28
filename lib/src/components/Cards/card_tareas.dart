import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CardTarea extends HookWidget {
  const CardTarea({
    Key? key,
    required this.title,
    required this.descripcion,
    required this.clase,
    required this.id,
  }) : super(key: key);

  final String title;
  final String descripcion;
  final String clase;
  final int id;

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
              Icons.library_books,
              color: Color(0xFFBFE3ED),
            ),
            title: Text(
              '${this.clase} - ${this.title}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              this.descripcion,
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
                  'VER TAREA',
                  style: TextStyle(
                    color: Color(0xFFBFE3ED),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/entregaTarea');
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
