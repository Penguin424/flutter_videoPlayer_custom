// To parse this JSON data, do
//
//     final detalleTareaDb = detalleTareaDbFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<DetalleTareaDb> detalleTareaDbFromJson(String str) =>
    List<DetalleTareaDb>.from(
        json.decode(str).map((x) => DetalleTareaDb.fromJson(x)));

String detalleTareaDbToJson(List<DetalleTareaDb> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetalleTareaDb {
  DetalleTareaDb({
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

  factory DetalleTareaDb.fromJson(Map<String, dynamic> json) => DetalleTareaDb(
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
