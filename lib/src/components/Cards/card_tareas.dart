import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class CardTarea extends HookWidget {
  const CardTarea({
    Key? key,
    required this.title,
    required this.descripcion,
    required this.clase,
    required this.id,
    required this.entr,
    required this.calificacion,
    required this.examen,
  }) : super(key: key);

  final String title;
  final String descripcion;
  final String clase;
  final int id;
  final bool entr;
  final int calificacion;
  final bool examen;

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
              '${this.clase} - ${this.title}  ${this.entr ? '\nPUNTOS: ${this.calificacion} ENTREGADA' : ''} ',
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
                onPressed: this.entr
                    ? null
                    : () {
                        if (PreferenceUtils.getString('role') == 'MAESTRO') {
                          Navigator.pushNamed(
                            context,
                            '/tareas',
                            arguments: {
                              'idTarea': id,
                            },
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            '/entregaTarea',
                            arguments: {
                              'idTarea': id,
                            },
                          );
                        }
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
