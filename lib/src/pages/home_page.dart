import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:reproductor/src/components/navigation_component.dart';
import 'package:reproductor/src/models/User.dart';

class PageHome extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      LocalStorage localStorage = LocalStorage('localStorage.json');

      print(localStorage.getItem('token'));
    }, []);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: NavigationBar(),
        body: ListView(
          padding: EdgeInsets.all(5),
          children: [
            card(context),
            card(context),
            card(context),
            card(context),
            card(context),
            card(context),
          ],
        ),
      ),
    );
  }

  Container card(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFF4CAAB1),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF36787D),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            'Carrera de Cosmetologia Facial Mayo 2021 Febrero'.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
            ),
            maxLines: 2,
            textAlign: TextAlign.justify,
            textDirection: TextDirection.ltr,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  'CLASES COMPLETADAS 7/24',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'QUIMICA COSMETOCA',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CONTINUAR CLASE',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/clase');
                },
                child: Icon(
                  Icons.chevron_right_sharp,
                  size: 32,
                  color: Color(0xFFBFE3ED),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
