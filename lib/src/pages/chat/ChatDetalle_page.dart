import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/src/multipart_file.dart' as mt;

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

// class ChatDetalle extends HookWidget {
//   const ChatDetalle({Key? key}) : super(key: key);
// }

class ChatDetalle extends StatefulWidget {
  ChatDetalle({Key? key}) : super(key: key);

  @override
  _ChatDetalleState createState() => _ChatDetalleState();
}

class _ChatDetalleState extends State<ChatDetalle> {
  GlobalController _controller = Get.find<GlobalController>();
  List<types.Message> _messages = [];
  types.User _user = types.User(
    id: Get.find<GlobalController>().idChat,
  );

  types.User _userRemote = types.User(
    id: Get.find<GlobalController>().usuarioChat.uid,
  );

  void _addMessage(types.Message message, String texto) {
    Get.find<GlobalController>().socket.emit(
      'mensaje-personal',
      {
        'de': Get.find<GlobalController>().idChat,
        'para': Get.find<GlobalController>().usuarioChat.uid,
        'mensaje': texto,
      },
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage, message.text);
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      final imageMul = mt.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: result.name,
      );

      String url = 'https://cosbiomeescuela.s3.us-east-2.amazonaws.com/';
      MultipartRequest request = MultipartRequest('POST', Uri.parse(url));
      request.files.add(imageMul);

      request.fields.addAll({
        'key': result.name,
      });
      StreamedResponse resa = await request.send();

      _addMessage(message, '${resa.request!.url.origin}/${result.name}');
    }
  }

  _addMessageFefore(types.Message textMessage) {
    if (mounted) {
      setState(
        () {
          _messages.insert(0, textMessage);
        },
      );
    }
  }

  onGetMessages() async {
    final resChat = await http.get(
      Uri.parse(
          'https://chat.cosbiome.online/api/mensajes/${Get.find<GlobalController>().usuarioChat.uid}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-token': Get.find<GlobalController>().token,
      },
    );

    if (resChat.statusCode == 200) {
      final mensajes = jsonDecode(resChat.body);
      setState(
        () {
          _messages = mensajes['mensajes'].map<types.Message>(
            (m) {
              final usuarios = [_user, _userRemote];
              if (m['mensaje'].startsWith('https')) {
                return types.ImageMessage(
                  author:
                      usuarios.firstWhere((element) => element.id == m['de']),
                  createdAt:
                      DateTime.parse(m['createdAt']).millisecondsSinceEpoch,
                  id: randomString(),
                  uri: m['mensaje'],
                  size: 20000,
                  name: m['mensaje'].split('/').last,
                );
              } else {
                return types.TextMessage(
                  author:
                      usuarios.firstWhere((element) => element.id == m['de']),
                  createdAt:
                      DateTime.parse(m['createdAt']).millisecondsSinceEpoch,
                  id: randomString(),
                  text: m['mensaje'],
                );
              }
            },
          ).toList();
        },
      );
    }

    Get.find<GlobalController>().socket.on(
      'mensaje-personal',
      (data) {
        print(data);
        final usuarios = [_user, _userRemote];
        late final textMessage;

        if (data['mensaje'].startsWith('https')) {
          textMessage = types.ImageMessage(
            author: usuarios.firstWhere((element) => element.id == data['de']),
            createdAt: DateTime.parse(data['createdAt']).millisecondsSinceEpoch,
            id: randomString(),
            uri: data['mensaje'],
            size: 20000,
            name: data['mensaje'].split('/').last,
          );
        } else {
          textMessage = types.TextMessage(
            author: usuarios.firstWhere((element) => element.id == data['de']),
            createdAt: DateTime.parse(data['createdAt']).millisecondsSinceEpoch,
            id: randomString(),
            text: data['mensaje'],
          );
        }

        _addMessageFefore(textMessage);
      },
    );
  }

  @override
  void initState() {
    onGetMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _.usuarioChat.nombre,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              color: Colors.black,
            ),
          ),
          body: Chat(
            messages: _messages,
            onSendPressed: _handleSendPressed,
            user: _user,
            showUserNames: true,
            disableImageGallery: false,
            onAttachmentPressed: _handleImageSelection,
          ),
        );
      },
    );
  }
}
