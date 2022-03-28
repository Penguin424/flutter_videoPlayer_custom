import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/user_chat_model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:http/http.dart' as http;
import 'package:reproductor/src/utils/PrefsSIngle.dart';

class ChatHome extends StatefulWidget {
  ChatHome({Key? key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  List<UserChatModel> users = [];
  final gContoller = Get.find<GlobalController>();

  @override
  void initState() {
    super.initState();

    handleGetUsers();
  }

  handleGetUsers() async {
    http.Response usersDB;

    final userMe = await HttpMod.get(
      'users/${PreferenceUtils.getString(("idUser"))}',
      {},
    );

    final bodyMeCursos =
        jsonDecode(userMe.body)['UsuarioCursos'] as List<dynamic>;

    List<int> cursosId = bodyMeCursos.map<int>((e) => e['id']).toList();

    if (PreferenceUtils.getString('role') == 'MAESTRO') {
      usersDB = await HttpMod.get('users', {
        '_limit': '1000000',
        "_sort": "username:ASC",
        "_where[0][AlumnoStatus]": "ACTIVO",
        "_where[1][role.name]": "ALUMNO",
        "_where[2][alumnoEstatusEstudio]": "CARRERA",
      });
    } else if (PreferenceUtils.getString('role') == 'ALUMNO') {
      usersDB = await HttpMod.get('users', {
        '_limit': '1000000',
        "_sort": "username:ASC",
        "_where[0][AlumnoStatus]": "ACTIVO",
        "_where[1][role.name]": "MAESTRO",
      });
    } else {
      usersDB = await HttpMod.get('users', {
        '_limit': '1000000',
        "_sort": "username:ASC",
        "_where[0][AlumnoStatus]": "ACTIVO",
        "_where[1][role.name]": "ALUMNO",
        "_where[2][alumnoEstatusEstudio]": "CARRERA",
      });
    }

    if (usersDB.statusCode == 200) {
      // List<UserChatModel> usuarios = [];
      List<UserChatModel> usersChatModelArray =
          jsonDecode(usersDB.body).map<UserChatModel>((user) {
        return UserChatModel.fromJson(user);
      }).toList();

      setState(() {
        users = usersChatModelArray;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Obx(
          () => Text(
            gContoller.serverStatus.value == ServerStatus.online
                ? 'Chat COSBIOME'.toUpperCase()
                : 'Chat COSBIOME (Offline)'.toUpperCase(),
            style: TextStyle(
              color: gContoller.serverStatus.value == ServerStatus.online
                  ? Colors.black
                  : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF4CAAB1),
                  child: Text(
                    user.username!.substring(0, 2),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(user.username!),
                subtitle: Text(user.email!),
                onTap: () {
                  Navigator.pushNamed(context, '/chat', arguments: user);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
