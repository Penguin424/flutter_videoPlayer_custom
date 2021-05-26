// To parse this JSON data, do
//
//     final pedidos = pedidosFromJson(jsonString);
import 'dart:convert';

Curso pedidosFromJson(String str) => Curso.fromJson(json.decode(str));

String pedidosToJson(Curso data) => json.encode(data.toJson());

class Curso {
  Curso({
    required this.id,
    required this.cursoTitulo,
    required this.cursoActivo,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String cursoTitulo;
  bool cursoActivo;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory Curso.fromJson(Map<String, dynamic> json) => Curso(
        id: json["id"],
        cursoTitulo: json["CursoTitulo"],
        cursoActivo: json["CursoActivo"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "CursoTitulo": cursoTitulo,
        "CursoActivo": cursoActivo,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
