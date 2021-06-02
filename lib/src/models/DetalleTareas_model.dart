// To parse this JSON data, do
//
//     final detalleTareas = detalleTareasFromJson(jsonString);

import 'dart:convert';

DetalleTareas detalleTareasFromJson(String str) =>
    DetalleTareas.fromJson(json.decode(str));

String detalleTareasToJson(DetalleTareas data) => json.encode(data.toJson());

class DetalleTareas {
  DetalleTareas({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.tareaDetDescripcion,
    required this.tareaDetArchivo,
    required this.tareaDetEntrega,
    required this.tareaDetCalificacion,
    required this.tareaDetAlumno,
    required this.tareaDetTarea,
    required this.tareaDetEntregada,
  });

  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String tareaDetDescripcion;
  String tareaDetArchivo;
  DateTime tareaDetEntrega;
  int tareaDetCalificacion;
  TareaDetAlumno tareaDetAlumno;
  TareaDetTarea tareaDetTarea;
  bool tareaDetEntregada;

  factory DetalleTareas.fromJson(Map<String, dynamic> json) => DetalleTareas(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        tareaDetDescripcion: json["TareaDetDescripcion"],
        tareaDetArchivo: json["TareaDetArchivo"],
        tareaDetEntrega: DateTime.parse(json["TareaDetEntrega"]),
        tareaDetCalificacion: json["TareaDetCalificacion"],
        tareaDetAlumno: TareaDetAlumno.fromJson(json["TareaDetAlumno"]),
        tareaDetTarea: TareaDetTarea.fromJson(json["TareaDetTarea"]),
        tareaDetEntregada: json["TareaDetEntregada"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "TareaDetDescripcion": tareaDetDescripcion,
        "TareaDetArchivo": tareaDetArchivo,
        "TareaDetEntrega": tareaDetEntrega.toIso8601String(),
        "TareaDetCalificacion": tareaDetCalificacion,
        "TareaDetAlumno": tareaDetAlumno.toJson(),
        "TareaDetTarea": tareaDetTarea.toJson(),
        "TareaDetEntregada": tareaDetEntregada,
      };
}

class TareaDetAlumno {
  TareaDetAlumno({
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

  factory TareaDetAlumno.fromJson(Map<String, dynamic> json) => TareaDetAlumno(
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

class TareaDetTarea {
  TareaDetTarea({
    required this.id,
    required this.tareaNombre,
    required this.tareaDescripcion,
    required this.tareaArchivo,
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
  String tareaArchivo;
  DateTime createdAt;
  DateTime updatedAt;
  int tareaClase;
  DateTime tareaEntrega;
  int tareaCurso;
  int tareaPuntos;
  bool tareaActiva;
  int tareaMaestro;

  factory TareaDetTarea.fromJson(Map<String, dynamic> json) => TareaDetTarea(
        id: json["id"],
        tareaNombre: json["TareaNombre"],
        tareaDescripcion: json["TareaDescripcion"],
        tareaArchivo: json["TareaArchivo"],
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
