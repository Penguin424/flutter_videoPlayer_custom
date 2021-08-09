// To parse this JSON data, do
//
//     final colegiatura = colegiaturaFromJson(jsonString);

import 'dart:convert';

Colegiatura colegiaturaFromJson(String str) =>
    Colegiatura.fromJson(json.decode(str));

String colegiaturaToJson(Colegiatura data) => json.encode(data.toJson());

class Colegiatura {
  Colegiatura({
    required this.id,
    required this.colegiaturaCantidad,
    required this.colegiaturaFecha,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String colegiaturaCantidad;
  String colegiaturaFecha;
  DateTime createdAt;
  DateTime updatedAt;

  factory Colegiatura.fromJson(Map<String, dynamic> json) => Colegiatura(
        id: json["id"],
        colegiaturaCantidad: json["ColegiaturaCantidad"],
        colegiaturaFecha: json["ColegiaturaFecha"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ColegiaturaCantidad": colegiaturaCantidad,
        "ColegiaturaFecha": colegiaturaFecha,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
