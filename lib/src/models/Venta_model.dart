// To parse this JSON data, do
//
//     final venta = ventaFromJson(jsonString);

import 'dart:convert';

Venta ventaFromJson(String str) => Venta.fromJson(json.decode(str));

String ventaToJson(Venta data) => json.encode(data.toJson());

class Venta {
  Venta({
    this.nombreCliente,
    this.numTel,
    this.productosCompra,
    this.medio,
    this.metodoDePago,
    this.total,
    this.subTotal,
    this.iva,
    this.de,
    this.a,
    this.fechaDeEntrega,
    this.nota,
    this.vendedor,
    this.idCliente,
    this.idFirebase,
    this.referencia,
    this.cargo,
    this.aparatado,
    this.abono,
    this.fechaVenta,
    this.horaVenta,
    this.idPedido,
    this.autorizado,
    this.vue,
    this.direccion,
    this.estatus,
  });

  String? nombreCliente;
  String? numTel;
  List<ProductosCompra>? productosCompra;
  String? medio;
  String? metodoDePago;
  double? total;
  double? subTotal;
  double? iva;
  String? estatus;
  String? de;
  String? a;
  String? fechaDeEntrega;
  String? nota;
  String? vendedor;
  String? idCliente;
  String? idFirebase;
  String? referencia;
  int? cargo;
  int? aparatado;
  bool? abono;
  String? fechaVenta;
  String? horaVenta;
  String? idPedido;
  String? autorizado;
  bool? vue;
  Direccion? direccion;

  factory Venta.fromJson(Map<String, dynamic> json) => Venta(
        nombreCliente: json["nombreCliente"],
        numTel: json["numTel"],
        productosCompra: List<ProductosCompra>.from(
            json["productosCompra"].map((x) => ProductosCompra.fromJson(x))),
        medio: json["medio"],
        metodoDePago: json["metodoDePago"],
        total: json["total"],
        subTotal: json["subTotal"],
        iva: json["iva"],
        estatus: json["estatus"],
        de: json["de"],
        a: json["a"],
        fechaDeEntrega: json["fechaDeEntrega"],
        nota: json["nota"],
        vendedor: json["vendedor"],
        idCliente: json["idCliente"],
        idFirebase: json["idFirebase"],
        referencia: json["referencia"],
        cargo: json["cargo"],
        aparatado: json["aparatado"],
        abono: json["abono"],
        fechaVenta: json["fechaVenta"],
        horaVenta: json["horaVenta"],
        idPedido: json["idPedido"],
        autorizado: json["autorizado"],
        vue: json["vue"],
        direccion: Direccion.fromJson(json["direccion"]),
      );

  Map<String, dynamic> toJson() => {
        "nombreCliente": nombreCliente,
        "numTel": numTel,
        "productosCompra":
            List<dynamic>.from(productosCompra!.map((x) => x.toJson())),
        "medio": medio,
        "metodoDePago": metodoDePago,
        "total": total,
        "subTotal": subTotal,
        "iva": iva,
        "de": de,
        "a": a,
        "fechaDeEntrega": fechaDeEntrega,
        "nota": nota,
        "vendedor": vendedor,
        "idCliente": idCliente,
        "idFirebase": idFirebase,
        "referencia": referencia,
        "cargo": cargo,
        "aparatado": aparatado,
        "abono": abono,
        "fechaVenta": fechaVenta,
        "horaVenta": horaVenta,
        "idPedido": idPedido,
        "autorizado": autorizado,
        "vue": vue,
        "direccion": direccion!.toJson(),
        "estatus": estatus,
      };
}

class Direccion {
  Direccion({
    this.domicilio,
    this.cruces,
    this.colonia,
    this.tipo,
    this.estado,
    this.codigoPostal,
    this.ciudad,
  });

  String? domicilio;
  String? cruces;
  String? colonia;
  String? tipo;
  String? estado;
  String? codigoPostal;
  String? ciudad;

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
        domicilio: json["domicilio"],
        cruces: json["cruces"],
        colonia: json["colonia"],
        tipo: json["tipo"],
        estado: json["estado"],
        codigoPostal: json["codigoPostal"],
        ciudad: json["ciudad"],
      );

  Map<String, dynamic> toJson() => {
        "domicilio": domicilio,
        "cruces": cruces,
        "colonia": colonia,
        "tipo": tipo,
        "estado": estado,
        "codigoPostal": codigoPostal,
        "ciudad": ciudad,
      };
}

class ProductosCompra {
  ProductosCompra({
    this.producto,
    this.precio,
    this.cantidad,
  });

  String? producto;
  double? precio;
  int? cantidad;

  factory ProductosCompra.fromJson(Map<String, dynamic> json) =>
      ProductosCompra(
        producto: json["producto"],
        precio: json["precio"],
        cantidad: json["cantidad"],
      );

  Map<String, dynamic> toJson() => {
        "producto": producto,
        "precio": precio,
        "cantidad": cantidad,
      };
}
