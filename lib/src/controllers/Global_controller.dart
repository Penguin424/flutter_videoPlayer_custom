import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/models/Alumno_model.dart';
import 'package:reproductor/src/models/Producto_model.dart';
import 'package:reproductor/src/models/UsuarioChat_model.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class GlobalController extends GetxController {
  List<ProductoShoppingCart> _productos = [];
  double _total = 0.0;
  List<ProductoShoppingCart> get productos => _productos;
  double get total => _total;
  late AlumnoDatos _alumno;
  AlumnoDatos get alumno => _alumno;
  DateTime _ultimoPago = DateTime.now();
  Rx<ServerStatus> serverStatus = ServerStatus.connecting.obs;
  DateTime get ultimoPago => _ultimoPago;
  String _token = "";
  String get token => _token;
  String _idChat = "";
  String get idChat => _idChat;
  late IO.Socket _socket;
  IO.Socket get socket => _socket;
  late UsuarioChat _usuarioChat;
  UsuarioChat get usuarioChat => _usuarioChat;
  int _idCurso = 0;
  int get idCurso => _idCurso;
  int _idClase = 0;
  int get idClase => _idClase;
  bool _chatAc = false;
  bool get chastAc => _chatAc;
  bool _fullScreen = false;
  bool get fullScreen => _fullScreen;

  @override
  void onInit() async {
    super.onInit();

    await PreferenceUtils.init();
  }

  setFullScreen(bool value) {
    _fullScreen = value;
  }

  onAddClaseId(idCl, bool chat) {
    _idClase = idCl;
    _chatAc = chat;
  }

  onAddOtraParte(UsuarioChat usuarioChat) {
    _usuarioChat = usuarioChat;
  }

  onAddTokenChat(String token, String id, idCursoF) {
    _token = token;
    _idChat = id;
    _idCurso = idCursoF;
    _socket = IO.io(
      'https://escuela.cosbiome.online/',
      {
        "transports": ["websocket"],
        "autoConnect": true,
      },
    );

    _socket.emit('subscribe', 'mensajes');

    _initConfigSockets();

    print(_socket.connected ? 'Conectado' : 'No conectado');

    if (!kIsWeb) {
      _socket.on(
        'create',
        (data) async {
          if (_idChat != data['de']) {
            if (data['mensaje'].startsWith('https')) {
              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 1,
                  channelKey: 'key1',
                  title: 'Nuevo mensaje con imagen',
                  bigPicture: data['mensaje'],
                  notificationLayout: NotificationLayout.BigPicture,
                ),
              );
            } else {
              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 1,
                  channelKey: 'key1',
                  title: 'Nuevo mensaje',
                  body: data['mensaje'],
                ),
              );
            }
          }
        },
      );
    }
  }

  void _initConfigSockets() {
    _socket.on('connect', (_) {
      serverStatus.value = ServerStatus.online;
    });
    _socket.on('disconnect', (_) {
      serverStatus.value = ServerStatus.offline;
    });
  }

  onAddUltimoPago(DateTime fecha) {
    _ultimoPago = fecha;
  }

  onAddAlumnoShop(String data) {
    _alumno = AlumnoDatos.fromJson(jsonDecode(data));
  }

  onAddAlumno(String data) {
    final datos = jsonDecode(data)['user'];
    final datosString = jsonEncode(datos);
    _alumno = AlumnoDatos.fromJson(jsonDecode(datosString));
  }

  onClearShoppingCart() {
    this._productos = [];

    update(['shopping_car']);
  }

  onAddShoppingCart(ProductoShoppingCart producto, BuildContext context) {
    final productoEcontrado = this
        ._productos
        .where((element) => element.name == producto.name)
        .toList();

    if (productoEcontrado.isEmpty) {
      if (producto.canitdadAlamacen < producto.canitdad) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'SI SUFICIENTE PRODUCTO EN ALAMACEN',
            ),
            backgroundColor: Color.fromRGBO(255, 0, 0, 1.0),
          ),
        );
      } else {
        _productos.add(producto);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${producto.canitdad} - AGREGADOS AL CARRITO',
            ),
            backgroundColor: Color.fromRGBO(76, 170, 177, 1.0),
          ),
        );
      }
    } else {
      if (producto.canitdadAlamacen <
          producto.canitdad + productoEcontrado.first.canitdad) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'SI SUFICIENTE PRODUCTO EN ALAMACEN',
            ),
            backgroundColor: Color.fromRGBO(255, 0, 0, 1.0),
          ),
        );
      } else {
        this._productos = this._productos.map(
          (elem) {
            if (elem.id == productoEcontrado[0].id) {
              elem.canitdad += producto.canitdad;
              elem.total = elem.canitdad * elem.price;

              return elem;
            }

            return elem;
          },
        ).toList();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${producto.canitdad} - AGREGADOS AL CARRITO',
            ),
            backgroundColor: Color.fromRGBO(76, 170, 177, 1.0),
          ),
        );
      }
    }

    _total = _productos.map((e) => e.total).toList().reduce(
          (value, element) => value + element,
        );

    update(['shopping_car']);
  }

  onRemoveShoppingCart(int id) {
    this._productos = _productos.where((element) => element.id != id).toList();

    if (this._productos.isEmpty) {
      this._total = 0.0;
    } else {
      _total = _productos.map((e) => e.total).toList().reduce(
            (value, element) => value + element,
          );
    }

    update(['shopping_car']);
  }
}
