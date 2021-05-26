// To parse this JSON data, do
//
//     final clases = clasesFromJson(jsonString);
import 'dart:convert';

Clase clasesFromJson(String str) => Clase.fromJson(json.decode(str));

String clasesToJson(Clase data) => json.encode(data.toJson());

class Clase {
  Clase({
    required this.id,
    required this.claseTitulo,
    required this.claseVideo,
    required this.claseActiva,
    required this.claseCurso,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String claseTitulo;
  String claseVideo;
  bool claseActiva;
  int claseCurso;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory Clase.fromJson(Map<String, dynamic> json) => Clase(
        id: json["id"],
        claseTitulo: json["ClaseTitulo"],
        claseVideo: json["ClaseVideo"],
        claseActiva: json["ClaseActiva"],
        claseCurso: json["ClaseCurso"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ClaseTitulo": claseTitulo,
        "ClaseVideo": claseVideo,
        "ClaseActiva": claseActiva,
        "ClaseCurso": claseCurso,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
