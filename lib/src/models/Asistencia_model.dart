// To parse this JSON data, do
//
//     final asistencia = asistenciaFromJson(jsonString);

import 'dart:convert';

Asistencia asistenciaFromJson(String str) =>
    Asistencia.fromJson(json.decode(str));

String asistenciaToJson(Asistencia data) => json.encode(data.toJson());

class Asistencia {
  Asistencia({
    required this.id,
    required this.asistenciaFecha,
    required this.asistenciaClase,
    required this.createdAt,
    required this.updatedAt,
    required this.asistenciaAlumno,
    required this.asistenciaCheck,
  });

  int id;
  DateTime asistenciaFecha;
  AsistenciaClase asistenciaClase;

  DateTime createdAt;
  DateTime updatedAt;
  AsistenciaAlumno asistenciaAlumno;
  bool asistenciaCheck;

  factory Asistencia.fromJson(Map<String, dynamic> json) => Asistencia(
        id: json["id"],
        asistenciaFecha: DateTime.parse(json["AsistenciaFecha"]),
        asistenciaClase: AsistenciaClase.fromJson(json["AsistenciaClase"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        asistenciaAlumno: AsistenciaAlumno.fromJson(json["AsistenciaAlumno"]),
        asistenciaCheck: json["AsistenciaCheck"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "AsistenciaFecha": asistenciaFecha.toIso8601String(),
        "AsistenciaClase": asistenciaClase.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "AsistenciaAlumno": asistenciaAlumno.toJson(),
        "AsistenciaCheck": asistenciaCheck,
      };
}

class AsistenciaAlumno {
  AsistenciaAlumno({
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

  factory AsistenciaAlumno.fromJson(Map<String, dynamic> json) =>
      AsistenciaAlumno(
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

class AsistenciaClase {
  AsistenciaClase({
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

  factory AsistenciaClase.fromJson(Map<String, dynamic> json) =>
      AsistenciaClase(
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
