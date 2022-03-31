///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class UserChatModelRole {
/*
{
  "id": 4,
  "name": "MAESTRO",
  "description": "ENTIDAD DE MAESTRO",
  "type": "naestro"
} 
*/

  int? id;
  String? name;
  String? description;
  String? type;

  UserChatModelRole({
    this.id,
    this.name,
    this.description,
    this.type,
  });
  UserChatModelRole.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    name = json['name']?.toString();
    description = json['description']?.toString();
    type = json['type']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['type'] = type;
    return data;
  }
}

class UserChatModel {
/*
{
  "id": 3,
  "username": "Juan Pablo Rizo Quintero",
  "email": "pablo.rizo@cosbiome.com",
  "provider": "local",
  "confirmed": true,
  "blocked": false,
  "role": {
    "id": 4,
    "name": "MAESTRO",
    "description": "ENTIDAD DE MAESTRO",
    "type": "naestro"
  },
  "created_at": "2021-05-28T14:56:50.000Z",
  "updated_at": "2022-01-06T20:20:57.000Z",
  "UsuarioFoto": "no",
  "AlumnoApellidoPaterno": "Rizo",
  "AlumnoApellidoMaterno": "Quintero",
  "AlumnoNombres": "Juan Pablo",
  "AlumnoFechaNacimiento": "29-06-2000",
  "AlumnoEstadoCivil": "Soltero",
  "AlumnoSexo": "Maculino",
  "AlumnoLugarDeNacimiento": "Mexico",
  "AlumnoEdad": "21",
  "AlumnoEscuelaDeTransferencia": "Unitec",
  "AlumnoTipoDeSangre": "o-",
  "AlumnoTelefono": "3319747514",
  "AlumnoCelular": "3319747514",
  "AlumnoTelefonoDeEmergencia": "3319747514",
  "AlumnoDomicilio": "Republica de costa rica 325",
  "AlumnoCodiPostal": "45550",
  "AlumnoPais": "Mexico",
  "AlumnoEstado": "Jalisco",
  "AlumnoMunicipio": "Tlaquepaque",
  "AlumnoRfc": "123sadas",
  "AlumnoCurp": "asdasdq123",
  "AlumnoMensualidad": "26000",
  "AlumnoCodigo": "319003",
  "AlumnoPresencial": true,
  "AlumnoLinea": true,
  "AlumnoVendedor": "Cristian Solis",
  "AlumnoPagoStripe": "price_1JLWNBHfPPJjPocOCjCUI8YT",
  "AlumnoEgresado": false,
  "AlumnoStatus": "ACTIVO"
} 
*/

  int? id;
  String? username;
  String? email;
  String? provider;
  bool? confirmed;
  bool? blocked;

  String? createdAt;
  String? updatedAt;
  String? UsuarioFoto;
  String? AlumnoApellidoPaterno;
  String? AlumnoApellidoMaterno;
  String? AlumnoNombres;
  String? AlumnoFechaNacimiento;
  String? AlumnoEstadoCivil;
  String? AlumnoSexo;
  String? AlumnoLugarDeNacimiento;
  String? AlumnoEdad;
  String? AlumnoEscuelaDeTransferencia;
  String? AlumnoTipoDeSangre;
  String? AlumnoTelefono;
  String? AlumnoCelular;
  String? AlumnoTelefonoDeEmergencia;
  String? AlumnoDomicilio;
  String? AlumnoCodiPostal;
  String? AlumnoPais;
  String? AlumnoEstado;
  String? AlumnoMunicipio;
  String? AlumnoRfc;
  String? AlumnoCurp;
  String? AlumnoMensualidad;
  String? AlumnoCodigo;
  bool? AlumnoPresencial;
  bool? AlumnoLinea;
  String? AlumnoVendedor;
  String? AlumnoPagoStripe;
  bool? AlumnoEgresado;
  String? AlumnoStatus;
  String? tokenpush;

  UserChatModel({
    this.id,
    this.username,
    this.email,
    this.provider,
    this.confirmed,
    this.blocked,
    this.createdAt,
    this.updatedAt,
    this.UsuarioFoto,
    this.AlumnoApellidoPaterno,
    this.AlumnoApellidoMaterno,
    this.AlumnoNombres,
    this.AlumnoFechaNacimiento,
    this.AlumnoEstadoCivil,
    this.AlumnoSexo,
    this.AlumnoLugarDeNacimiento,
    this.AlumnoEdad,
    this.AlumnoEscuelaDeTransferencia,
    this.AlumnoTipoDeSangre,
    this.AlumnoTelefono,
    this.AlumnoCelular,
    this.AlumnoTelefonoDeEmergencia,
    this.AlumnoDomicilio,
    this.AlumnoCodiPostal,
    this.AlumnoPais,
    this.AlumnoEstado,
    this.AlumnoMunicipio,
    this.AlumnoRfc,
    this.AlumnoCurp,
    this.AlumnoMensualidad,
    this.AlumnoCodigo,
    this.AlumnoPresencial,
    this.AlumnoLinea,
    this.AlumnoVendedor,
    this.AlumnoPagoStripe,
    this.AlumnoEgresado,
    this.AlumnoStatus,
    this.tokenpush,
  });
  UserChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    username = json['username']?.toString();
    email = json['email']?.toString();
    provider = json['provider']?.toString();
    confirmed = json['confirmed'];
    blocked = json['blocked'];

    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    UsuarioFoto = json['UsuarioFoto']?.toString();
    AlumnoApellidoPaterno = json['AlumnoApellidoPaterno']?.toString();
    AlumnoApellidoMaterno = json['AlumnoApellidoMaterno']?.toString();
    AlumnoNombres = json['AlumnoNombres']?.toString();
    AlumnoFechaNacimiento = json['AlumnoFechaNacimiento']?.toString();
    AlumnoEstadoCivil = json['AlumnoEstadoCivil']?.toString();
    AlumnoSexo = json['AlumnoSexo']?.toString();
    AlumnoLugarDeNacimiento = json['AlumnoLugarDeNacimiento']?.toString();
    AlumnoEdad = json['AlumnoEdad']?.toString();
    AlumnoEscuelaDeTransferencia =
        json['AlumnoEscuelaDeTransferencia']?.toString();
    AlumnoTipoDeSangre = json['AlumnoTipoDeSangre']?.toString();
    AlumnoTelefono = json['AlumnoTelefono']?.toString();
    AlumnoCelular = json['AlumnoCelular']?.toString();
    AlumnoTelefonoDeEmergencia = json['AlumnoTelefonoDeEmergencia']?.toString();
    AlumnoDomicilio = json['AlumnoDomicilio']?.toString();
    AlumnoCodiPostal = json['AlumnoCodiPostal']?.toString();
    AlumnoPais = json['AlumnoPais']?.toString();
    AlumnoEstado = json['AlumnoEstado']?.toString();
    AlumnoMunicipio = json['AlumnoMunicipio']?.toString();
    AlumnoRfc = json['AlumnoRfc']?.toString();
    AlumnoCurp = json['AlumnoCurp']?.toString();
    AlumnoMensualidad = json['AlumnoMensualidad']?.toString();
    AlumnoCodigo = json['AlumnoCodigo']?.toString();
    AlumnoPresencial = json['AlumnoPresencial'];
    AlumnoLinea = json['AlumnoLinea'];
    AlumnoVendedor = json['AlumnoVendedor']?.toString();
    AlumnoPagoStripe = json['AlumnoPagoStripe']?.toString();
    AlumnoEgresado = json['AlumnoEgresado'];
    AlumnoStatus = json['AlumnoStatus']?.toString();
    tokenpush = json['tokenpush']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['provider'] = provider;
    data['confirmed'] = confirmed;
    data['blocked'] = blocked;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['UsuarioFoto'] = UsuarioFoto;
    data['AlumnoApellidoPaterno'] = AlumnoApellidoPaterno;
    data['AlumnoApellidoMaterno'] = AlumnoApellidoMaterno;
    data['AlumnoNombres'] = AlumnoNombres;
    data['AlumnoFechaNacimiento'] = AlumnoFechaNacimiento;
    data['AlumnoEstadoCivil'] = AlumnoEstadoCivil;
    data['AlumnoSexo'] = AlumnoSexo;
    data['AlumnoLugarDeNacimiento'] = AlumnoLugarDeNacimiento;
    data['AlumnoEdad'] = AlumnoEdad;
    data['AlumnoEscuelaDeTransferencia'] = AlumnoEscuelaDeTransferencia;
    data['AlumnoTipoDeSangre'] = AlumnoTipoDeSangre;
    data['AlumnoTelefono'] = AlumnoTelefono;
    data['AlumnoCelular'] = AlumnoCelular;
    data['AlumnoTelefonoDeEmergencia'] = AlumnoTelefonoDeEmergencia;
    data['AlumnoDomicilio'] = AlumnoDomicilio;
    data['AlumnoCodiPostal'] = AlumnoCodiPostal;
    data['AlumnoPais'] = AlumnoPais;
    data['AlumnoEstado'] = AlumnoEstado;
    data['AlumnoMunicipio'] = AlumnoMunicipio;
    data['AlumnoRfc'] = AlumnoRfc;
    data['AlumnoCurp'] = AlumnoCurp;
    data['AlumnoMensualidad'] = AlumnoMensualidad;
    data['AlumnoCodigo'] = AlumnoCodigo;
    data['AlumnoPresencial'] = AlumnoPresencial;
    data['AlumnoLinea'] = AlumnoLinea;
    data['AlumnoVendedor'] = AlumnoVendedor;
    data['AlumnoPagoStripe'] = AlumnoPagoStripe;
    data['AlumnoEgresado'] = AlumnoEgresado;
    data['AlumnoStatus'] = AlumnoStatus;
    data['tokenpush'] = tokenpush;
    return data;
  }
}
