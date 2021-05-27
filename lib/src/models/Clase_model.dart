// To parse this JSON data, do
//
//     final clase = claseFromJson(jsonString);
import 'dart:convert';

Clase claseFromJson(String str) => Clase.fromJson(json.decode(str));

String claseToJson(Clase data) => json.encode(data.toJson());

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
    required this.clasemaestro,
  });

  int id;
  String claseTitulo;
  String claseVideo;
  bool claseActiva;
  ClaseCurso claseCurso;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  Clasemaestro clasemaestro;

  factory Clase.fromJson(Map<String, dynamic> json) => Clase(
        id: json["id"],
        claseTitulo: json["ClaseTitulo"],
        claseVideo: json["ClaseVideo"],
        claseActiva: json["ClaseActiva"],
        claseCurso: ClaseCurso.fromJson(json["ClaseCurso"]),
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        clasemaestro: Clasemaestro.fromJson(json["Clasemaestro"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ClaseTitulo": claseTitulo,
        "ClaseVideo": claseVideo,
        "ClaseActiva": claseActiva,
        "ClaseCurso": claseCurso.toJson(),
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "Clasemaestro": clasemaestro.toJson(),
      };
}

class ClaseCurso {
  ClaseCurso({
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

  factory ClaseCurso.fromJson(Map<String, dynamic> json) => ClaseCurso(
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

class Clasemaestro {
  Clasemaestro({
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

  factory Clasemaestro.fromJson(Map<String, dynamic> json) => Clasemaestro(
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
      };
}
