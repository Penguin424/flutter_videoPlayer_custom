import 'dart:convert';
import 'dart:math';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as web;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/controllers/notificaciones_controller.dart';
import 'package:reproductor/src/models/mensajes_model.dart';
import 'package:reproductor/src/models/notificacion_data_model.dart';
import 'package:reproductor/src/models/user_chat_model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class ChatAlumnoPage extends StatefulWidget {
  ChatAlumnoPage({Key? key}) : super(key: key);

  @override
  State<ChatAlumnoPage> createState() => _ChatAlumnoPageState();
}

class _ChatAlumnoPageState extends State<ChatAlumnoPage>
    with SingleTickerProviderStateMixin {
  List<Mensajes> mensajes = [];
  String mensaje = "";
  TextEditingController mensajeCOntroller = TextEditingController();
  bool emojiShowing = false;
  bool isClipPresed = false;
  FocusNode focus = FocusNode();
  late AnimationController animationController;
  late Animation<double> animation;
  final gController = Get.find<GlobalController>();
  ScrollController scrollController = ScrollController();
  bool needScroll = false;
  bool isLoading = false;
  final userChatCurrent = Get.find<NotificacionesContoller>().userChat.value;

  @override
  void initState() {
    super.initState();
    handleGetMenssages();

    gController.socket.on('create', (data) {
      if (mounted) {
        handleGetMenssages();
        setState(() {
          needScroll = true;
        });
      }
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
  }

  void onFocusKeyBoard() {
    if (emojiShowing) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  scrollToEnd() {
    scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    // scrollController.jumpTo(scrollController.position.maxScrollExtent);
    setState(() {
      needScroll = false;
    });
  }

  Future<void> handleGetMenssages() async {
    await PreferenceUtils.init();

    focus.addListener(onFocusKeyBoard);

    final argunemnts =
        ModalRoute.of(context)!.settings.arguments as UserChatModel;

    final mensajesDBDe = await HttpMod.get(
      'mensajes',
      {
        "_where[0][de.username]": PreferenceUtils.getString('userName'),
        "_where[1][para.username]": '${argunemnts.username}',
      },
    );

    final mensajesDBPara = await HttpMod.get(
      'mensajes',
      {
        "_where[0][de.username]": '${argunemnts.username}',
        "_where[1][para.username]": PreferenceUtils.getString('userName'),
      },
    );

    if (mensajesDBDe.statusCode == 200 && mensajesDBPara.statusCode == 200) {
      List<Mensajes> mensajesConvert = [];

      List<Mensajes> mensajesConvertDe = jsonDecode(mensajesDBDe.body)
          .map<Mensajes>((json) => Mensajes.fromJson(json))
          .toList();

      List<Mensajes> mensajesConvertPara = jsonDecode(mensajesDBPara.body)
          .map<Mensajes>((json) => Mensajes.fromJson(json))
          .toList();

      mensajesConvert.addAll(mensajesConvertDe);
      mensajesConvert.addAll(mensajesConvertPara);
      mensajesConvert.sort((a, b) {
        final fecha1 = DateTime.parse(
          a.createdAt!,
        ).microsecondsSinceEpoch;
        final fecha2 = DateTime.parse(
          b.createdAt!,
        ).microsecondsSinceEpoch;
        return fecha2.compareTo(fecha1);
      });

      setState(() {
        mensajes = mensajesConvert;

        isLoading = true;
      });
    }
  }

  _onEmojiSelected(Emoji emoji) {
    setState(() {
      mensaje = mensaje + emoji.emoji;
    });
    mensajeCOntroller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: mensajeCOntroller.text.length,
        ),
      );
  }

  _onBackspacePressed() {
    setState(() {
      mensaje = mensaje.substring(0, mensaje.length - 1);
    });
    mensajeCOntroller
      ..text = mensajeCOntroller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: mensajeCOntroller.text.length,
        ),
      );
  }

  Future<void> getImageFilePicker(int para, UserChatModel userMen) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final mensajeDB = await HttpMod.post(
        'mensajes',
        jsonEncode(
          {
            "mensaje": "",
            "de": PreferenceUtils.getString("idUser"),
            "para": para,
          },
        ),
      );

      if (mensajeDB.statusCode == 200) {
        if (!web.kIsWeb) {
          await HttpMod.sendNotify(
            userMen.tokenpush == null ? '' : userMen.tokenpush!,
            NotificacionData(
              title:
                  'Nuevo mensaje de ${PreferenceUtils.getString("userName")}',
              body: mensaje,
            ),
            {
              "usserMessage": jsonEncode(userChatCurrent.toJson()),
            },
          );
        }

        setState(() {
          mensaje = "";
          mensajeCOntroller.text = "";
          FocusScope.of(context).requestFocus(FocusNode());
          emojiShowing = false;
        });
      }
    }
  }

  Future handleSendMessage(int para, UserChatModel userMen) async {
    final idUsuarioActual = PreferenceUtils.getString("idUser");

    final mensajeDB = await HttpMod.post(
      'mensajes',
      jsonEncode(
        {
          "mensaje": mensaje,
          "de": idUsuarioActual,
          "para": para,
        },
      ),
    );

    if (mensajeDB.statusCode == 200) {
      if (!web.kIsWeb) {
        await HttpMod.sendNotify(
          userMen.tokenpush == null
              ? 'dMO2jF9VTgWVvVldU1Ne0A:APA91bEucHDEQ2nxNHmqNU6U6EKqLrsJhEy29GVRQvFzYjytACAYQM-qCpxLHAX_3FtF9HKjf-38FuJdEDuOw_ZT6Ue6Uj1H_43ABlYvAFkdMLOa33ZaNXCMKmQ0CA-QvU-iR3lxnX7u'
              : userMen.tokenpush!,
          NotificacionData(
            title: 'Nuevo mensaje de ${PreferenceUtils.getString("userName")}',
            body: mensaje,
          ),
          {
            "usserMessage": jsonEncode(userChatCurrent.toJson()),
          },
        );
      }

      setState(() {
        mensaje = "";
        mensajeCOntroller.text = "";
        FocusScope.of(context).requestFocus(FocusNode());
        emojiShowing = false;
      });
    }
  }

  Future<void> getImadeForImagePIckerSourceCamera(
      int para, UserChatModel userMen) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final urlImage = await HttpMod.loadImage(
        await image.readAsBytes(),
        image,
      );

      final mensajeDB = await HttpMod.post(
        'mensajes',
        jsonEncode(
          {
            "mensaje": urlImage,
            "de": PreferenceUtils.getString("idUser"),
            "para": para,
          },
        ),
      );

      if (mensajeDB.statusCode == 200) {
        if (!web.kIsWeb) {
          await HttpMod.sendNotify(
            userMen.tokenpush == null
                ? 'dMO2jF9VTgWVvVldU1Ne0A:APA91bEucHDEQ2nxNHmqNU6U6EKqLrsJhEy29GVRQvFzYjytACAYQM-qCpxLHAX_3FtF9HKjf-38FuJdEDuOw_ZT6Ue6Uj1H_43ABlYvAFkdMLOa33ZaNXCMKmQ0CA-QvU-iR3lxnX7u'
                : userMen.tokenpush!,
            NotificacionData(
              title:
                  'Nuevo mensaje de ${PreferenceUtils.getString("userName")}',
              body: urlImage,
            ),
            {
              "usserMessage": jsonEncode(userChatCurrent.toJson()),
            },
          );
        }

        setState(() {
          mensaje = "";
          mensajeCOntroller.text = "";
          FocusScope.of(context).requestFocus(FocusNode());
          emojiShowing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    focus.removeListener(onFocusKeyBoard);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final argumanets =
        ModalRoute.of(context)!.settings.arguments as UserChatModel;

    if (needScroll) {
      scrollToEnd();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        "https://avatars1.githubusercontent.com/u/17098981?s=460&v=4",
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          argumanets.AlumnoApellidoPaterno! +
                              " " +
                              argumanets.AlumnoNombres!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Hoy",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.secondary,
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              SizedBox(
                height: size.height * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: createListMessages(size),
                ),
              ),
              Positioned(
                bottom: !emojiShowing ? 0 : 250,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    emojiShowing = !emojiShowing;
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  });
                                },
                                icon: !emojiShowing
                                    ? const Icon(Icons.insert_emoticon_sharp)
                                    : const Icon(Icons.keyboard),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: mensajeCOntroller,
                                  onChanged: (value) {
                                    setState(() {
                                      mensaje = value;
                                    });
                                  },
                                  focusNode: focus,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      left: 15,
                                      bottom: 11,
                                      top: 11,
                                      right: 15,
                                    ),
                                    hintText: 'Mensaje',
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: -pi / 4,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isClipPresed = !isClipPresed;
                                      if (animationController.status ==
                                              AnimationStatus.forward ||
                                          animationController.status ==
                                              AnimationStatus.completed) {
                                        animationController.reverse();
                                      } else {
                                        animationController.forward();
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.attach_file),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    getImadeForImagePIckerSourceCamera(
                                  argumanets.id!,
                                  argumanets,
                                ),
                                icon: const Icon(Icons.camera_alt),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: size.width * 0.12,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          onPressed: mensaje.isNotEmpty
                              ? () =>
                                  handleSendMessage(argumanets.id!, argumanets)
                              : null,
                          icon: mensaje.isNotEmpty
                              ? const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.keyboard_voice_sharp,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 70,
                child: CircularRevealAnimation(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 250,
                    width: size.width * 0.95,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  animation: animation,
                  centerAlignment: Alignment.bottomCenter,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Offstage(
                  offstage: !emojiShowing,
                  child: SizedBox(
                    height: 250,
                    width: size.width,
                    child: EmojiPicker(
                      onEmojiSelected: (Category category, Emoji emoji) {
                        _onEmojiSelected(emoji);
                      },
                      onBackspacePressed: _onBackspacePressed,
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * 1,
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        initCategory: Category.RECENT,
                        bgColor: Theme.of(context).colorScheme.secondary,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        iconColor: Colors.grey,
                        iconColorSelected:
                            Theme.of(context).colorScheme.primary,
                        progressIndicatorColor:
                            Theme.of(context).colorScheme.primary,
                        backspaceColor: Theme.of(context).colorScheme.primary,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        noRecentsText: 'No Recents',
                        noRecentsStyle: const TextStyle(
                            fontSize: 20, color: Colors.black26),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createListMessages(Size size) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      reverse: true,
      itemCount: mensajes.length,
      itemBuilder: (context, index) {
        final mensaje = mensajes[index];
        final idUsuarioMensaje = mensaje.de!.id;
        final idUsuarioActual = PreferenceUtils.getString('idUser');
        final isMe = idUsuarioMensaje == int.parse(idUsuarioActual);

        if (mensaje.mensaje!.startsWith('https://')) {
          return Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 1.8,
                ),
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.8,
                  minHeight: size.height * 0.06,
                  minWidth: size.width * 0.3,
                  maxHeight: size.height * 0.36,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        mensaje.mensaje!,
                        fit: BoxFit.cover,
                        height: size.height * 0.3,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      DateFormat('HH:mm a').format(
                        DateTime.parse(mensaje.createdAt!).toLocal(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 1.8,
                ),
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.8,
                  minHeight: size.height * 0.06,
                  minWidth: size.width * 0.3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Text(
                      mensaje.mensaje!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      DateFormat('HH:mm a').format(
                        DateTime.parse(mensaje.createdAt!).toLocal(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
