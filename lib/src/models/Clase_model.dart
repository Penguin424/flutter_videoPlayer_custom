// To parse this JSON data, do
//
//     final clase = claseFromJson(jsonString);
import 'dart:convert';

List<Clase> claseFromJson(String str) =>
    List<Clase>.from(json.decode(str).map((x) => Clase.fromJson(x)));

String claseToJson(List<Clase> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
    required this.claseTarea,
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
  List<ClaseTarea> claseTarea;

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
        claseTarea: List<ClaseTarea>.from(
            json["ClaseTarea"].map((x) => ClaseTarea.fromJson(x))),
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
        "ClaseTarea": List<dynamic>.from(claseTarea.map((x) => x.toJson())),
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

class ClaseTarea {
  ClaseTarea({
    required this.id,
    required this.tareaNombre,
    required this.tareaDescripcion,
    required this.tareaArchivo,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.tareaClase,
    required this.tareaEntrega,
    required this.tareaCurso,
    required this.tareaPuntos,
    required this.tareaActiva,
    required this.tareaMaestro,
  });

  int id;
  String tareaNombre;
  String tareaDescripcion;
  dynamic tareaArchivo;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int tareaClase;
  DateTime tareaEntrega;
  int tareaCurso;
  int tareaPuntos;
  bool tareaActiva;
  int tareaMaestro;

  factory ClaseTarea.fromJson(Map<String, dynamic> json) => ClaseTarea(
        id: json["id"],
        tareaNombre: json["TareaNombre"],
        tareaDescripcion: json["TareaDescripcion"],
        tareaArchivo: json["TareaArchivo"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        tareaClase: json["TareaClase"],
        tareaEntrega: DateTime.parse(json["TareaEntrega"]),
        tareaCurso: json["TareaCurso"],
        tareaPuntos: json["TareaPuntos"],
        tareaActiva: json["TareaActiva"],
        tareaMaestro: json["TareaMaestro"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "TareaNombre": tareaNombre,
        "TareaDescripcion": tareaDescripcion,
        "TareaArchivo": tareaArchivo,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "TareaClase": tareaClase,
        "TareaEntrega": tareaEntrega.toIso8601String(),
        "TareaCurso": tareaCurso,
        "TareaPuntos": tareaPuntos,
        "TareaActiva": tareaActiva,
        "TareaMaestro": tareaMaestro,
      };
}

class Clasemaestro {
  Clasemaestro({
    required this.id,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String username;
  String email;
  String provider;
  bool confirmed;
  bool blocked;
  int role;
  DateTime createdAt;
  DateTime updatedAt;

  factory Clasemaestro.fromJson(Map<String, dynamic> json) => Clasemaestro(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        role: json["role"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "provider": provider,
        "confirmed": confirmed,
        "blocked": blocked,
        "role": role,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
