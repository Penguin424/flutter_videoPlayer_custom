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
        hideSignUpButton: true,
        hideForgotPasswordButton: true,
        loginAfterSignUp: false,
        onLogin: (value) async {
          final res = await HttpMod.login(value);
          if (res.statusCode == 200) {
            Navigator.pushNamed(context, '/home');
          } else {
            _showDialog(context);
          }
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

  Future<void> _showDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('asdasd'),
          actions: [
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }
}
