// To parse this JSON data, do
//
//     final tarea = tareaFromJson(jsonString);
import 'dart:convert';

Tarea tareaFromJson(String str) => Tarea.fromJson(json.decode(str));

String tareaToJson(Tarea data) => json.encode(data.toJson());

class Tarea {
  Tarea({
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
    required this.tareaDetalles,
  });

  int id;
  String tareaNombre;
  String tareaDescripcion;
  dynamic tareaArchivo;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  TareaClase tareaClase;
  DateTime tareaEntrega;
  TareaCurso tareaCurso;
  int tareaPuntos;
  bool tareaActiva;
  TareaMaestro tareaMaestro;
  List<TareaDetalle> tareaDetalles;

  factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        id: json["id"],
        tareaNombre: json["TareaNombre"],
        tareaDescripcion: json["TareaDescripcion"],
        tareaArchivo: json["TareaArchivo"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        tareaClase: TareaClase.fromJson(json["TareaClase"]),
        tareaEntrega: DateTime.parse(json["TareaEntrega"]),
        tareaCurso: TareaCurso.fromJson(json["TareaCurso"]),
        tareaPuntos: json["TareaPuntos"],
        tareaActiva: json["TareaActiva"],
        tareaMaestro: TareaMaestro.fromJson(json["TareaMaestro"]),
        tareaDetalles: List<TareaDetalle>.from(
            json["TareaDetalles"].map((x) => TareaDetalle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "TareaNombre": tareaNombre,
        "TareaDescripcion": tareaDescripcion,
        "TareaArchivo": tareaArchivo,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "TareaClase": tareaClase.toJson(),
        "TareaEntrega": tareaEntrega.toIso8601String(),
        "TareaCurso": tareaCurso.toJson(),
        "TareaPuntos": tareaPuntos,
        "TareaActiva": tareaActiva,
        "TareaMaestro": tareaMaestro.toJson(),
        "TareaDetalles":
            List<dynamic>.from(tareaDetalles.map((x) => x.toJson())),
      };
}

class TareaClase {
  TareaClase({
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

  factory TareaClase.fromJson(Map<String, dynamic> json) => TareaClase(
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

class TareaCurso {
  TareaCurso({
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

  factory TareaCurso.fromJson(Map<String, dynamic> json) => TareaCurso(
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

class TareaDetalle {
  TareaDetalle({
    required this.id,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.tareaDetDescripcion,
    required this.tareaDetArchivo,
    required this.tareaDetEntrega,
    required this.tareaDetCalificacion,
    required this.tareaDetAlumno,
    required this.tareaDetTarea,
  });

  int id;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  String tareaDetDescripcion;
  dynamic tareaDetArchivo;
  DateTime tareaDetEntrega;
  int tareaDetCalificacion;
  int tareaDetAlumno;
  int tareaDetTarea;

  factory TareaDetalle.fromJson(Map<String, dynamic> json) => TareaDetalle(
        id: json["id"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        tareaDetDescripcion: json["TareaDetDescripcion"],
        tareaDetArchivo: json["TareaDetArchivo"],
        tareaDetEntrega: DateTime.parse(json["TareaDetEntrega"]),
        tareaDetCalificacion: json["TareaDetCalificacion"],
        tareaDetAlumno: json["TareaDetAlumno"],
        tareaDetTarea: json["TareaDetTarea"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "TareaDetDescripcion": tareaDetDescripcion,
        "TareaDetArchivo": tareaDetArchivo,
        "TareaDetEntrega": tareaDetEntrega.toIso8601String(),
        "TareaDetCalificacion": tareaDetCalificacion,
        "TareaDetAlumno": tareaDetAlumno,
        "TareaDetTarea": tareaDetTarea,
      };
}

class TareaMaestro {
  TareaMaestro({
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

  factory TareaMaestro.fromJson(Map<String, dynamic> json) => TareaMaestro(
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
