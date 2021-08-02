// To parse this JSON data, do
//
//     final tarea = tareaFromJson(jsonString);

import 'dart:convert';

Producto tareaFromJson(String str) => Producto.fromJson(json.decode(str));

String tareaToJson(Producto data) => json.encode(data.toJson());

class Producto {
  Producto({
    required this.name,
    required this.image,
    required this.price,
  });

  String name;
  String image;
  double price;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        name: json["name"],
        image: json["image"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "price": price,
      };
}

class ProductoShoppingCart {
  ProductoShoppingCart({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.canitdad,
    required this.total,
  });

  int id;
  String name;
  String image;
  double price;
  int canitdad;
  double total;

  factory ProductoShoppingCart.fromJson(Map<String, dynamic> json) =>
      ProductoShoppingCart(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        canitdad: json['cantidad'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
        "cantidad": canitdad,
        "total": total,
      };
}
