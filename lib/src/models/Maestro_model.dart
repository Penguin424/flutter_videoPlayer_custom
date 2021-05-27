// To parse this JSON data, do
//
//     final maestro = maestroFromJson(jsonString);
import 'dart:convert';

import 'package:reproductor/src/models/Clase_model.dart';

Maestro maestroFromJson(String str) => Maestro.fromJson(json.decode(str));

String maestroToJson(Maestro data) => json.encode(data.toJson());

class Maestro {
  Maestro({
    required this.id,
    required this.mestroNombre,
    required this.maestroColonia,
    required this.maestroEstado,
    required this.maestroCodigoPostal,
    required this.maestroDireccion,
    required this.maestroTelefono,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.mestroClases,
  });

  int id;
  String mestroNombre;
  String maestroColonia;
  String maestroEstado;
  String maestroCodigoPostal;
  String maestroDireccion;
  String maestroTelefono;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  List<Clase> mestroClases;

  factory Maestro.fromJson(Map<String, dynamic> json) => Maestro(
        id: json["id"],
        mestroNombre: json["MestroNombre"],
        maestroColonia: json["MaestroColonia"],
        maestroEstado: json["MaestroEstado"],
        maestroCodigoPostal: json["MaestroCodigoPostal"],
        maestroDireccion: json["MaestroDireccion"],
        maestroTelefono: json["MaestroTelefono"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        mestroClases: List<Clase>.from(
            json["MestroClases"].map((x) => Clase.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "MestroNombre": mestroNombre,
        "MaestroColonia": maestroColonia,
        "MaestroEstado": maestroEstado,
        "MaestroCodigoPostal": maestroCodigoPostal,
        "MaestroDireccion": maestroDireccion,
        "MaestroTelefono": maestroTelefono,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "MestroClases": List<dynamic>.from(mestroClases.map((x) => x.toJson())),
      };
}
