import 'dart:convert';

import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/User.dart';
import 'dart:async';

import 'package:reproductor/src/utils/PrefsSIngle.dart';

class HttpMod {
  static final HttpMod _httpMod = HttpMod._internal();
  factory HttpMod() => _httpMod;
  HttpMod._internal();

  static LocalStorage localStorage = LocalStorage('localStorage.json');
  // static dynamic _token = 'jhgjhjh';
  static Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  static Map<String, String> _headersAuth = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${PreferenceUtils.getString('token')}',
  };
  static String _host = 'escuela.cosbiome.online';
  // static int _port = 3001;

  static Future<http.Response> login(LoginData loginData) async {
    final url = Uri(
      host: _host,
      // port: _port,
      scheme: 'https',
      path: '/auth/local',
    );

    http.Response response = await http.post(
      url,
      body: jsonEncode(
        {
          'identifier': loginData.name,
          'password': loginData.password,
        },
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final controller = Get.find<GlobalController>();
      final user = User.fromJson(jsonDecode(response.body));
      LocalStorage _localStorage = LocalStorage('localStorage.json');
      bool localCard = await _localStorage.ready;
      if (localCard) {
        controller.onAddAlumno(response.body);

        await PreferenceUtils.init();

        await _localStorage.setItem('token', user.jwt);
        await _localStorage.setItem('idUser', user.user.id);
        await _localStorage.setItem('userName', user.user.username);
        await _localStorage.setItem('role', user.user.role.name);
        await _localStorage.setItem('imagenPerfil', user.user.usuarioFoto);
        await _localStorage.setItem('isLogged', true);

        PreferenceUtils.putString('token', user.jwt);
        PreferenceUtils.putString('idUser', user.user.id.toString());
        PreferenceUtils.putString('userName', user.user.username);
        PreferenceUtils.putString('role', user.user.role.name);
        PreferenceUtils.putString('imagenPerfil', user.user.usuarioFoto);
        PreferenceUtils.putBool('isLogged', true);
        PreferenceUtils.putString('email', user.user.email);
        PreferenceUtils.putString('password', loginData.password);
      }

      return response;
    } else {
      return response;
    }
  }

  static Future<http.Response> post(
    String path,
    String body,
  ) async {
    final url = Uri(
      host: _host,
      // port: _port,
      scheme: 'https',
      path: path,
    );

    final response = await http.post(
      url,
      body: body,
      headers: _headersAuth,
    );

    return response;
  }

  static Future<http.Response> get(
    String path,
    Map<String, String>? parameters,
  ) async {
    final url = Uri(
      host: _host,
      scheme: 'https',
      // port: _port,
      queryParameters: parameters,
      path: path,
    );
    final response = await http.get(
      url,
      headers: _headersAuth,
    );

    return response;
  }

  static Future<http.Response> update(
    String path,
    String body,
  ) async {
    final url = Uri(
      host: _host,
      scheme: 'https',
      // port: _port,
      path: path,
    );
    final response = await http.put(
      url,
      body: body,
      headers: _headersAuth,
    );

    return response;
  }

  static Future<http.Response> delete(
    String path,
  ) async {
    final url = Uri(
      host: _host,
      scheme: 'https',
      // port: _port,
      path: path,
    );
    final response = await http.delete(
      url,
      headers: _headersAuth,
    );

    return response;
  }
}
