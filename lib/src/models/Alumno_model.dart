// To parse this JSON data, do
//
//     final alumnoDatos = alumnoDatosFromJson(jsonString);

import 'dart:convert';

AlumnoDatos alumnoDatosFromJson(String str) =>
    AlumnoDatos.fromJson(json.decode(str));

String alumnoDatosToJson(AlumnoDatos data) => json.encode(data.toJson());

class AlumnoDatos {
  AlumnoDatos({
    this.alumnoApellidoPaterno,
    this.alumnoApellidoMaterno,
    this.alumnoNombres,
    this.alumnoCelular,
    this.alumnoDomicilio,
    this.alumnoCodiPostal,
    this.alumnoPais,
    this.alumnoEstado,
    this.alumnoMunicipio,
    this.alumnoVendedor,
  });

  String? alumnoApellidoPaterno;
  String? alumnoApellidoMaterno;
  String? alumnoNombres;
  String? alumnoCelular;
  String? alumnoDomicilio;
  String? alumnoCodiPostal;
  String? alumnoPais;
  String? alumnoEstado;
  String? alumnoMunicipio;
  String? alumnoVendedor;

  factory AlumnoDatos.fromJson(Map<String, dynamic> json) => AlumnoDatos(
      alumnoApellidoPaterno: json["AlumnoApellidoPaterno"],
      alumnoApellidoMaterno: json["AlumnoApellidoMaterno"],
      alumnoNombres: json["AlumnoNombres"],
      alumnoCelular: json["AlumnoCelular"],
      alumnoDomicilio: json["AlumnoDomicilio"],
      alumnoCodiPostal: json["AlumnoCodiPostal"],
      alumnoPais: json["AlumnoPais"],
      alumnoEstado: json["AlumnoEstado"],
      alumnoMunicipio: json["AlumnoMunicipio"],
      alumnoVendedor: json["AlumnoVendedor"]);

  Map<String, dynamic> toJson() => {
        "AlumnoApellidoPaterno": alumnoApellidoPaterno,
        "AlumnoApellidoMaterno": alumnoApellidoMaterno,
        "AlumnoNombres": alumnoNombres,
        "AlumnoCelular": alumnoCelular,
        "AlumnoDomicilio": alumnoDomicilio,
        "AlumnoCodiPostal": alumnoCodiPostal,
        "AlumnoPais": alumnoPais,
        "AlumnoEstado": alumnoEstado,
        "AlumnoMunicipio": alumnoMunicipio,
        "AlumnoVendedor": alumnoVendedor
      };
}
