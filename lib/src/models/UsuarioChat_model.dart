// To parse this JSON data, do
//
//     final usuarioChat = usuarioChatFromJson(jsonString);

import 'dart:convert';

UsuarioChat usuarioChatFromJson(String str) =>
    UsuarioChat.fromJson(json.decode(str));

String usuarioChatToJson(UsuarioChat data) => json.encode(data.toJson());

class UsuarioChat {
  UsuarioChat({
    required this.online,
    required this.nombre,
    required this.email,
    required this.uid,
  });

  bool online;
  String nombre;
  String email;
  String uid;

  factory UsuarioChat.fromJson(Map<String, dynamic> json) => UsuarioChat(
        online: json["online"],
        nombre: json["nombre"],
        email: json["email"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "uid": uid,
      };
}
