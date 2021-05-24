import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:reproductor/src/models/User.dart';

class LoginPage extends StatelessWidget {
  // const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        onRecoverPassword: (pass) async {
          return '';
        },
        onLogin: (value) async {
          final url = Uri(host: 'localhost', path: '/auth/local', port: 1337);
          final data = await http.post(
            url,
            body: jsonEncode(
              {
                'identifier': value.name,
                'password': value.password,
              },
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json'
            },
          );
          final user = User.fromJson(jsonDecode(data.body));
          LocalStorage localStorage = LocalStorage('localStorage.json');

          localStorage.setItem('token', user.jwt);
          localStorage.setItem('idUser', user.user.id);
          localStorage.setItem('userName', user.user.username);
          localStorage.setItem('user', jsonEncode(user.toJson()));
          Navigator.pushNamed(context, '/home');
        },
        onSignup: (data) async {
          return '';
        },
        title: 'Escuela Cosbiome',
        theme: LoginTheme(
          pageColorLight: Color(0xFFBFE3ED),
          primaryColor: Color(0xFF4CAAB1),
        ),
      ),
    );
  }
}
