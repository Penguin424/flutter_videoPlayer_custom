// To parse this JSON data, do
//
//     final pedidos = pedidosFromJson(jsonString);
// To parse this JSON data, do
//
//     final curso = cursoFromJson(jsonString);
import 'dart:convert';

Curso cursoFromJson(String str) => Curso.fromJson(json.decode(str));

String cursoToJson(Curso data) => json.encode(data.toJson());

class Curso {
  Curso({
    required this.id,
    required this.cursoTitulo,
    required this.cursoActivo,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.cursoClases,
    required this.cursoAlumnos,
  });

  int id;
  String cursoTitulo;
  bool cursoActivo;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  List<CursoClase> cursoClases;
  List<CursoAlumno> cursoAlumnos;

  factory Curso.fromJson(Map<String, dynamic> json) => Curso(
        id: json["id"],
        cursoTitulo: json["CursoTitulo"],
        cursoActivo: json["CursoActivo"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        cursoClases: List<CursoClase>.from(
            json["CursoClases"].map((x) => CursoClase.fromJson(x))),
        cursoAlumnos: List<CursoAlumno>.from(
            json["CursoAlumnos"].map((x) => CursoAlumno.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "CursoTitulo": cursoTitulo,
        "CursoActivo": cursoActivo,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "CursoClases": List<dynamic>.from(cursoClases.map((x) => x.toJson())),
        "CursoAlumnos": List<dynamic>.from(cursoAlumnos.map((x) => x.toJson())),
      };
}

class CursoAlumno {
  CursoAlumno({
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

  factory CursoAlumno.fromJson(Map<String, dynamic> json) => CursoAlumno(
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

class CursoClase {
  CursoClase({
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
  int claseCurso;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int clasemaestro;

  factory CursoClase.fromJson(Map<String, dynamic> json) => CursoClase(
        id: json["id"],
        claseTitulo: json["ClaseTitulo"],
        claseVideo: json["ClaseVideo"],
        claseActiva: json["ClaseActiva"],
        claseCurso: json["ClaseCurso"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        clasemaestro: json["Clasemaestro"],
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
        "Clasemaestro": clasemaestro,
      };
}
