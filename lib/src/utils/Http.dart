import 'dart:convert';

import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:reproductor/src/models/User.dart';
import 'dart:async';

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
    'Authorization': 'Bearer ${localStorage.getItem('token')}',
  };
  static String _host = 'localhost';
  static int _port = 1337;

  static Future<http.Response> login(LoginData loginData) async {
    final url = Uri(
      host: _host,
      port: _port,
      scheme: 'http',
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
      final user = User.fromJson(jsonDecode(response.body));
      LocalStorage _localStorage = LocalStorage('localStorage.json');
      _localStorage.setItem('token', user.jwt);
      _localStorage.setItem('idUser', user.user.id);
      _localStorage.setItem('userName', user.user.username);

      return response;
    } else {
      return response;
    }
  }

  static Future<http.Response> post(
    String path,
    String body, [
    String parameters = '',
  ]) async {
    final url = Uri(
      host: _host,
      port: _port,
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
      port: _port,
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
    Map<String, String>? parameters,
  ) async {
    final url = Uri(
      host: _host,
      port: _port,
      path: path,
      queryParameters: parameters,
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
    Map<String, String>? parameters,
  ) async {
    final url = Uri(
      host: _host,
      port: _port,
      path: path,
      queryParameters: parameters,
    );
    final response = await http.put(
      url,
      headers: _headersAuth,
    );

    return response;
  }
}
