import 'dart:convert';

List<ExamenesDb> examenesDbFromJson(String str) =>
    List<ExamenesDb>.from(json.decode(str).map((x) => ExamenesDb.fromJson(x)));

String examenesDbToJson(List<ExamenesDb> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExamenesDb {
  ExamenesDb({
    required this.id,
    required this.examenTitulo,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.curso,
    required this.examenpreguntas,
    required this.tiempo,
    required this.detalleexamenes,
  });

  final int id;
  final String examenTitulo;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Curso curso;
  final List<Examenpregunta> examenpreguntas;
  final int tiempo;
  List<Detalleexamene> detalleexamenes;

  factory ExamenesDb.fromJson(Map<String, dynamic> json) => ExamenesDb(
        id: json["id"],
        examenTitulo: json["examenTitulo"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        curso: Curso.fromJson(json["curso"]),
        examenpreguntas: List<Examenpregunta>.from(
            json["examenpreguntas"].map((x) => Examenpregunta.fromJson(x))),
        tiempo: json["tiempo"],
        detalleexamenes: List<Detalleexamene>.from(
            json["detalleexamenes"].map((x) => Detalleexamene.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "examenTitulo": examenTitulo,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "curso": curso.toJson(),
        "examenpreguntas":
            List<dynamic>.from(examenpreguntas.map((x) => x.toJson())),
        "tiempo": tiempo,
        "detalleexamenes":
            List<dynamic>.from(detalleexamenes.map((x) => x.toJson())),
      };
}

class Curso {
  Curso({
    required this.id,
    required this.cursoTitulo,
    required this.cursoActivo,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String cursoTitulo;
  final bool cursoActivo;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

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

class Examenpregunta {
  Examenpregunta({
    required this.id,
    required this.respuestas,
    required this.pregunta,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.examen,
    required this.respuesta,
  });

  final int id;
  final List<RespuestaElement> respuestas;
  final String pregunta;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int examen;
  final RespuestaEnum respuesta;

  factory Examenpregunta.fromJson(Map<String, dynamic> json) => Examenpregunta(
        id: json["id"],
        respuestas: List<RespuestaElement>.from(
            json["respuestas"].map((x) => RespuestaElement.fromJson(x))),
        pregunta: json["pregunta"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        examen: json["examen"],
        respuesta: respuestaEnumValues.map[json["respuesta"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "respuestas": List<dynamic>.from(respuestas.map((x) => x.toJson())),
        "pregunta": pregunta,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "examen": examen,
        "respuesta": respuestaEnumValues.reverse[respuesta],
      };
}

class Detalleexamene {
  Detalleexamene({
    required this.id,
    required this.alumno,
    required this.examen,
    required this.calificacion,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int alumno;
  int examen;
  double calificacion;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory Detalleexamene.fromJson(Map<String, dynamic> json) => Detalleexamene(
        id: json["id"],
        alumno: json["alumno"],
        examen: json["examen"],
        calificacion: json["calificacion"].toDouble(),
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "alumno": alumno,
        "examen": examen,
        "calificacion": calificacion,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

enum RespuestaEnum { ID_1, ID_2, ID_3 }

final respuestaEnumValues = EnumValues({
  "id_1": RespuestaEnum.ID_1,
  "id_2": RespuestaEnum.ID_2,
  "id_3": RespuestaEnum.ID_3
});

class RespuestaElement {
  RespuestaElement({
    required this.id,
    required this.option,
  });

  final RespuestaEnum id;
  final String option;

  factory RespuestaElement.fromJson(Map<String, dynamic> json) =>
      RespuestaElement(
        id: respuestaEnumValues.map[json["id"]]!,
        option: json["option"],
      );

  Map<String, dynamic> toJson() => {
        "id": respuestaEnumValues.reverse[id],
        "option": option,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
