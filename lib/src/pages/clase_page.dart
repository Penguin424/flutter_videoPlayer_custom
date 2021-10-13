import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:reproductor/src/components/VideoPlayFull.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/multipart_file.dart' as mt;

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ClasePage extends StatefulWidget {
  ClasePage({Key? key}) : super(key: key);

  @override
  _ClasePageState createState() => _ClasePageState();
}

class _ClasePageState extends State<ClasePage> {
  GlobalController _controller = Get.find<GlobalController>();
  List<types.Message> _messages = [];
  List<types.User> _users = [];
  types.User _user = types.User(
    id: Get.find<GlobalController>().idChat,
  );

  void _addMessage(types.Message message, String texto) {
    _controller.socket.emit(
      'mensaje-clase',
      {
        'de': _controller.idChat,
        'para': _controller.idChat,
        'mensaje': texto,
        'clase': _controller.idClase,
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
        'https://chat.cosbiome.online/api/mensajes/clase/${_controller.idClase}',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-token': _controller.token,
      },
    );

    print(resChat.body);

    if (resChat.statusCode == 200) {
      final mensajes = jsonDecode(resChat.body);
      setState(
        () {
          _users = mensajes['mensajes']
              .map<types.User>(
                (u) => types.User(
                  id: u['de'],
                ),
              )
              .toList();

          _messages = mensajes['mensajes'].map<types.Message>(
            (m) {
              final usuarios = _users;
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

    _controller.socket.on(
      'mensaje-clase',
      (data) {
        print(data);
        final usuarios = _users;
        late final textMessage;
        final userExit = _users.where((element) => element.id == data['de']);

        if (userExit.length == 0) {
          _users.add(
            types.User(
              id: data['de'],
            ),
          );
        }

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
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final params =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   toolbarHeight: 0.1,
      //   backwardsCompatibility: false,
      //   systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      // ),
      body: GetBuilder<GlobalController>(builder: (_) {
        return SingleChildScrollView(
          physics:
              _.fullScreen ? NeverScrollableScrollPhysics() : ScrollPhysics(),
          child: Column(
            children: [
              VideoPlayerFull(
                url: params['video'],
                title: params['titulo'],
              ),
              // SizedBox(
              //   height: 20,
              // ),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: _controller.chastAc
                    ? Chat(
                        messages: _messages,
                        onSendPressed: _handleSendPressed,
                        user: _user,
                        showUserNames: true,
                        disableImageGallery: false,
                        onAttachmentPressed: _handleImageSelection,
                      )
                    : Center(
                        child: Text('DISFRUTA TU CLASE'),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
