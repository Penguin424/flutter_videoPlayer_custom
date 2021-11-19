// To parse this JSON data, do
//
//     final alumnoDb = alumnoDbFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AlumnoDb alumnoDbFromJson(String str) => AlumnoDb.fromJson(json.decode(str));

String alumnoDbToJson(AlumnoDb data) => json.encode(data.toJson());

class AlumnoDb {
  AlumnoDb({
    required this.id,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.usuarioFoto,
    required this.alumnoApellidoPaterno,
    required this.alumnoApellidoMaterno,
    required this.alumnoNombres,
    required this.alumnoFechaNacimiento,
    required this.alumnoEstadoCivil,
    required this.alumnoSexo,
    required this.alumnoLugarDeNacimiento,
    required this.alumnoEdad,
    required this.alumnoEscuelaDeTransferencia,
    required this.alumnoTipoDeSangre,
    required this.alumnoTelefono,
    required this.alumnoCelular,
    required this.alumnoTelefonoDeEmergencia,
    required this.alumnoDomicilio,
    required this.alumnoCodiPostal,
    required this.alumnoPais,
    required this.alumnoEstado,
    required this.alumnoMunicipio,
    required this.alumnoRfc,
    required this.alumnoCurp,
    required this.alumnoMensualidad,
    required this.alumnoCodigo,
    required this.alumnoPresencial,
    required this.alumnoLinea,
    required this.alumnoVendedor,
    required this.alumnoPagoStripe,
    required this.alumnoEgresado,
    required this.usuarioCursos,
    required this.alumnoTareas,
    required this.maestroTarea,
    required this.mestroClases,
    required this.alumnoAsistencias,
    required this.alumnoColegiatura,
  });

  int id;
  String username;
  String email;
  String provider;
  bool confirmed;
  bool blocked;
  Role role;
  DateTime createdAt;
  DateTime updatedAt;
  String usuarioFoto;
  String alumnoApellidoPaterno;
  String alumnoApellidoMaterno;
  String alumnoNombres;
  String alumnoFechaNacimiento;
  String alumnoEstadoCivil;
  String alumnoSexo;
  String alumnoLugarDeNacimiento;
  String alumnoEdad;
  String alumnoEscuelaDeTransferencia;
  String alumnoTipoDeSangre;
  String alumnoTelefono;
  String alumnoCelular;
  String alumnoTelefonoDeEmergencia;
  String alumnoDomicilio;
  String alumnoCodiPostal;
  String alumnoPais;
  String alumnoEstado;
  String alumnoMunicipio;
  String alumnoRfc;
  String alumnoCurp;
  String alumnoMensualidad;
  String alumnoCodigo;
  bool alumnoPresencial;
  bool alumnoLinea;
  String alumnoVendedor;
  String alumnoPagoStripe;
  bool alumnoEgresado;
  List<UsuarioCurso> usuarioCursos;
  List<AlumnoTarea> alumnoTareas;
  List<dynamic> maestroTarea;
  List<dynamic> mestroClases;
  List<AlumnoAsistencia> alumnoAsistencias;
  List<AlumnoColegiatura> alumnoColegiatura;

  factory AlumnoDb.fromJson(Map<String, dynamic> json) => AlumnoDb(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        role: Role.fromJson(json["role"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        usuarioFoto: json["UsuarioFoto"],
        alumnoApellidoPaterno: json["AlumnoApellidoPaterno"],
        alumnoApellidoMaterno: json["AlumnoApellidoMaterno"],
        alumnoNombres: json["AlumnoNombres"],
        alumnoFechaNacimiento: json["AlumnoFechaNacimiento"],
        alumnoEstadoCivil: json["AlumnoEstadoCivil"],
        alumnoSexo: json["AlumnoSexo"],
        alumnoLugarDeNacimiento: json["AlumnoLugarDeNacimiento"],
        alumnoEdad: json["AlumnoEdad"],
        alumnoEscuelaDeTransferencia: json["AlumnoEscuelaDeTransferencia"],
        alumnoTipoDeSangre: json["AlumnoTipoDeSangre"],
        alumnoTelefono: json["AlumnoTelefono"],
        alumnoCelular: json["AlumnoCelular"],
        alumnoTelefonoDeEmergencia: json["AlumnoTelefonoDeEmergencia"],
        alumnoDomicilio: json["AlumnoDomicilio"],
        alumnoCodiPostal: json["AlumnoCodiPostal"],
        alumnoPais: json["AlumnoPais"],
        alumnoEstado: json["AlumnoEstado"],
        alumnoMunicipio: json["AlumnoMunicipio"],
        alumnoRfc: json["AlumnoRfc"],
        alumnoCurp: json["AlumnoCurp"],
        alumnoMensualidad: json["AlumnoMensualidad"],
        alumnoCodigo: json["AlumnoCodigo"],
        alumnoPresencial: json["AlumnoPresencial"],
        alumnoLinea: json["AlumnoLinea"],
        alumnoVendedor: json["AlumnoVendedor"],
        alumnoPagoStripe: json["AlumnoPagoStripe"],
        alumnoEgresado: json["AlumnoEgresado"],
        usuarioCursos: List<UsuarioCurso>.from(
            json["UsuarioCursos"].map((x) => UsuarioCurso.fromJson(x))),
        alumnoTareas: List<AlumnoTarea>.from(
            json["AlumnoTareas"].map((x) => AlumnoTarea.fromJson(x))),
        maestroTarea: List<dynamic>.from(json["MaestroTarea"].map((x) => x)),
        mestroClases: List<dynamic>.from(json["MestroClases"].map((x) => x)),
        alumnoAsistencias: List<AlumnoAsistencia>.from(
            json["AlumnoAsistencias"].map((x) => AlumnoAsistencia.fromJson(x))),
        alumnoColegiatura: List<AlumnoColegiatura>.from(
            json["AlumnoColegiatura"]
                .map((x) => AlumnoColegiatura.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "provider": provider,
        "confirmed": confirmed,
        "blocked": blocked,
        "role": role.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "UsuarioFoto": usuarioFoto,
        "AlumnoApellidoPaterno": alumnoApellidoPaterno,
        "AlumnoApellidoMaterno": alumnoApellidoMaterno,
        "AlumnoNombres": alumnoNombres,
        "AlumnoFechaNacimiento": alumnoFechaNacimiento,
        "AlumnoEstadoCivil": alumnoEstadoCivil,
        "AlumnoSexo": alumnoSexo,
        "AlumnoLugarDeNacimiento": alumnoLugarDeNacimiento,
        "AlumnoEdad": alumnoEdad,
        "AlumnoEscuelaDeTransferencia": alumnoEscuelaDeTransferencia,
        "AlumnoTipoDeSangre": alumnoTipoDeSangre,
        "AlumnoTelefono": alumnoTelefono,
        "AlumnoCelular": alumnoCelular,
        "AlumnoTelefonoDeEmergencia": alumnoTelefonoDeEmergencia,
        "AlumnoDomicilio": alumnoDomicilio,
        "AlumnoCodiPostal": alumnoCodiPostal,
        "AlumnoPais": alumnoPais,
        "AlumnoEstado": alumnoEstado,
        "AlumnoMunicipio": alumnoMunicipio,
        "AlumnoRfc": alumnoRfc,
        "AlumnoCurp": alumnoCurp,
        "AlumnoMensualidad": alumnoMensualidad,
        "AlumnoCodigo": alumnoCodigo,
        "AlumnoPresencial": alumnoPresencial,
        "AlumnoLinea": alumnoLinea,
        "AlumnoVendedor": alumnoVendedor,
        "AlumnoPagoStripe": alumnoPagoStripe,
        "AlumnoEgresado": alumnoEgresado,
        "UsuarioCursos":
            List<dynamic>.from(usuarioCursos.map((x) => x.toJson())),
        "AlumnoTareas": List<dynamic>.from(alumnoTareas.map((x) => x.toJson())),
        "MaestroTarea": List<dynamic>.from(maestroTarea.map((x) => x)),
        "MestroClases": List<dynamic>.from(mestroClases.map((x) => x)),
        "AlumnoAsistencias":
            List<dynamic>.from(alumnoAsistencias.map((x) => x.toJson())),
        "AlumnoColegiatura":
            List<dynamic>.from(alumnoColegiatura.map((x) => x.toJson())),
      };
}

class AlumnoAsistencia {
  AlumnoAsistencia({
    required this.id,
    required this.asistenciaCechk,
    required this.asistenciaFecha,
    required this.asistenciaClase,
    required this.createdAt,
    required this.updatedAt,
    required this.asistenciaAlumno,
    required this.asistenciaCheck,
  });

  int id;
  dynamic asistenciaCechk;
  DateTime asistenciaFecha;
  int asistenciaClase;
  DateTime createdAt;
  DateTime updatedAt;
  int asistenciaAlumno;
  bool asistenciaCheck;

  factory AlumnoAsistencia.fromJson(Map<String, dynamic> json) =>
      AlumnoAsistencia(
        id: json["id"],
        asistenciaCechk: json["AsistenciaCechk"],
        asistenciaFecha: DateTime.parse(json["AsistenciaFecha"]),
        asistenciaClase: json["AsistenciaClase"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        asistenciaAlumno: json["AsistenciaAlumno"],
        asistenciaCheck: json["AsistenciaCheck"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "AsistenciaCechk": asistenciaCechk,
        "AsistenciaFecha": asistenciaFecha.toIso8601String(),
        "AsistenciaClase": asistenciaClase,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "AsistenciaAlumno": asistenciaAlumno,
        "AsistenciaCheck": asistenciaCheck,
      };
}

class AlumnoColegiatura {
  AlumnoColegiatura({
    required this.id,
    required this.colegiaturaCantidad,
    required this.colegiaturaFecha,
    required this.createdAt,
    required this.updatedAt,
    required this.colegiaturaAlumno,
    required this.colegiaturaReferencia,
  });

  int id;
  String colegiaturaCantidad;
  String colegiaturaFecha;
  DateTime createdAt;
  DateTime updatedAt;
  int colegiaturaAlumno;
  String colegiaturaReferencia;

  factory AlumnoColegiatura.fromJson(Map<String, dynamic> json) =>
      AlumnoColegiatura(
        id: json["id"],
        colegiaturaCantidad: json["ColegiaturaCantidad"],
        colegiaturaFecha: json["ColegiaturaFecha"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        colegiaturaAlumno: json["ColegiaturaAlumno"],
        colegiaturaReferencia: json["ColegiaturaReferencia"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ColegiaturaCantidad": colegiaturaCantidad,
        "ColegiaturaFecha": colegiaturaFecha,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "ColegiaturaAlumno": colegiaturaAlumno,
        "ColegiaturaReferencia": colegiaturaReferencia,
      };
}

class AlumnoTarea {
  AlumnoTarea({
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
  int tareaDetAlumno;
  int tareaDetTarea;
  bool tareaDetEntregada;

  factory AlumnoTarea.fromJson(Map<String, dynamic> json) => AlumnoTarea(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        tareaDetDescripcion: json["TareaDetDescripcion"],
        tareaDetArchivo: json["TareaDetArchivo"],
        tareaDetEntrega: DateTime.parse(json["TareaDetEntrega"]),
        tareaDetCalificacion: json["TareaDetCalificacion"],
        tareaDetAlumno: json["TareaDetAlumno"],
        tareaDetTarea: json["TareaDetTarea"] ?? 0,
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
        "TareaDetAlumno": tareaDetAlumno,
        "TareaDetTarea": tareaDetTarea,
        "TareaDetEntregada": tareaDetEntregada,
      };
}

class Role {
  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
  });

  int id;
  String name;
  String description;
  String type;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "type": type,
      };
}

class UsuarioCurso {
  UsuarioCurso({
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

  factory UsuarioCurso.fromJson(Map<String, dynamic> json) => UsuarioCurso(
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
