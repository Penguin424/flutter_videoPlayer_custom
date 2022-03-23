import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/UsuarioChat_model.dart';
import 'package:reproductor/src/pages/chat/ChatDetalle_page.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class ChatHome extends HookWidget {

// }

class ChatHome extends StatefulWidget {
  ChatHome({Key? key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  // const ChatHome({Key? key}) : super(key: key);

  List<UsuarioChat> _usuarioschat = [];
  List<String> _nombres = [];

  void getUsersChat() async {
    final contoller = Get.find<GlobalController>();

    final resChatMaestos = await HttpMod.get(
      '/users',
      {
        '_where[0][role.name]': 'MAESTRO',
        '_where[0][UsuarioCursos.id]': contoller.idCurso.toString(),
      },
    );

    List<String> nombres = [];
    if (resChatMaestos.statusCode == 200) {
      final maestros = jsonDecode(resChatMaestos.body);

      for (var maestro in maestros) {
        nombres.add(maestro['username']);
      }

      setState(() {
        _nombres = nombres;
      });
    }

    final resChat = await http.get(
      Uri.parse('https://chat.cosbiome.online/api/login/usuarios'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-token': contoller.token,
      },
    );

    if (resChat.statusCode == 200) {
      final usuarios = jsonDecode(resChat.body)['usuarios'];

      List<UsuarioChat> usuariosChat = [];
      for (var usuario in usuarios) {
        UsuarioChat usuarioChat = UsuarioChat.fromJson(usuario);

        if (PreferenceUtils.getString('role') != 'MAESTRO') {
          for (var item in nombres) {
            if (item == usuarioChat.nombre) usuariosChat.add(usuarioChat);
          }
        } else {
          usuariosChat.add(usuarioChat);
        }
      }
      setState(() {
        _usuarioschat = usuariosChat
            .where((element) =>
                element.nombre != PreferenceUtils.getString('userName'))
            .toList();
      });
    }

    contoller.socket.on(
      'lista-usuarios',
      (usuarios) {
        print(usuarios);
        List<UsuarioChat> usuariosChat = [];
        for (var usuario in usuarios) {
          UsuarioChat usuarioChat = UsuarioChat.fromJson(usuario);

          if (PreferenceUtils.getString('role') != 'MAESTRO') {
            for (var item in nombres) {
              if (item == usuarioChat.nombre) usuariosChat.add(usuarioChat);
            }
          } else {
            usuariosChat.add(usuarioChat);
          }
        }

        if (mounted) {
          setState(() {
            _usuarioschat = usuariosChat
                .where((element) =>
                    element.nombre != PreferenceUtils.getString('userName'))
                .toList();
          });
        }
      },
    );
  }

  @override
  void initState() {
    getUsersChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (_) => Scaffold(
        body: _usuarioschat.length > 0
            ? ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemCount: _usuarioschat.length,
                itemBuilder: (context, index) {
                  final usuariochat = _usuarioschat[index];

                  return ListTile(
                    title: Text(
                      usuariochat.nombre,
                    ),
                    subtitle: Text(
                      '${usuariochat.online ? 'CONECTADO' : 'DESCONECTADO'}',
                    ),
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                        maxWidth: 64,
                        maxHeight: 64,
                      ),
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                        scale: 1.3,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: Color.fromRGBO(76, 170, 177, 1.0),
                      ),
                      onPressed: () {
                        _.onAddOtraParte(usuariochat);
                        Navigator.pushNamed(context, '/detalleChat');
                      },
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(76, 170, 177, 1.0),
                ),
              ),
      ),
    );
  }
}
