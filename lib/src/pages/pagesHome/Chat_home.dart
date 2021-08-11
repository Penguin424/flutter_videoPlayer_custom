import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/UsuarioChat_model.dart';
import 'package:reproductor/src/pages/chat/ChatDetalle_page.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatHome extends HookWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _usuarioschat = useState<List<UsuarioChat>>([]);

    void getUsersChat() async {
      final contoller = Get.find<GlobalController>();

      final resChat = await http.get(
        Uri.parse('http://192.168.68.124:8080/api/login/usuarios'),
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

          usuariosChat.add(usuarioChat);
        }

        _usuarioschat.value = usuariosChat;
      }

      contoller.socket.on(
        'lista-usuarios',
        (usuarios) {
          print(usuarios);
          List<UsuarioChat> usuariosChat = [];
          for (var usuario in usuarios) {
            UsuarioChat usuarioChat = UsuarioChat.fromJson(usuario);

            usuariosChat.add(usuarioChat);
          }

          _usuarioschat.value = usuariosChat;
        },
      );
    }

    useEffect(() {
      getUsersChat();
    }, []);

    return GetBuilder<GlobalController>(
      builder: (_) => Scaffold(
        body: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: _usuarioschat.value.length,
          itemBuilder: (context, index) {
            final usuariochat = _usuarioschat.value[index];

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
        ),
      ),
    );
  }
}
