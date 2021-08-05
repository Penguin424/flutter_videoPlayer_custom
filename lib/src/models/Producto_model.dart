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
    required this.cantidad,
  });

  String name;
  String image;
  double price;
  int cantidad;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        name: json["name"],
        image: json["image"],
        price: json["price"],
        cantidad: json["cantidad"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "price": price,
        "cantidad": cantidad,
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
    required this.canitdadAlamacen,
  });

  int id;
  String name;
  String image;
  double price;
  int canitdad;
  int canitdadAlamacen;
  double total;

  factory ProductoShoppingCart.fromJson(Map<String, dynamic> json) =>
      ProductoShoppingCart(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        canitdad: json['cantidad'],
        total: json['total'],
        canitdadAlamacen: json['canitdadAlamacen'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
        "cantidad": canitdad,
        "total": total,
        "canitdadAlamacen": canitdadAlamacen,
      };
}
