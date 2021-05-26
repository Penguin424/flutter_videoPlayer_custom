import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:reproductor/src/utils/Http.dart';

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
          HttpMod.login(value);
          Navigator.pushNamed(context, '/home');
        },
        onSignup: (data) async {
          return '';
        },
        title: 'Escuela Cosbiome',
        theme: LoginTheme(
          titleStyle: TextStyle(
            fontSize: 26,
          ),
          pageColorLight: Color(0xFFBFE3ED),
          primaryColor: Color(0xFF4CAAB1),
        ),
      ),
    );
  }
}
