// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.jwt,
    required this.user,
  });

  String jwt;
  UserClass user;

  factory User.fromJson(Map<String, dynamic> json) => User(
        jwt: json["jwt"],
        user: UserClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "jwt": jwt,
        "user": user.toJson(),
      };
}

class UserClass {
  UserClass({
    required this.id,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.usuarioCursos,
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
  List<UsuarioCurso> usuarioCursos;

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        role: Role.fromJson(json["role"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        usuarioCursos: List<UsuarioCurso>.from(
            json["UsuarioCursos"].map((x) => UsuarioCurso.fromJson(x))),
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
        "UsuarioCursos":
            List<dynamic>.from(usuarioCursos.map((x) => x.toJson())),
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
